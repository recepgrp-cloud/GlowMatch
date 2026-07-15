import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'product_matcher.dart';

class AIService {
  static final Uri _functionUrl = Uri.parse(
    'https://us-central1-glowmatch-560b1.cloudfunctions.net/analyzeFace',
  );

  final ProductMatcher _productMatcher = ProductMatcher();

  Future<Map<String, dynamic>> analyzeFace(XFile image) async {
    try {
      final Uint8List imageBytes = await image.readAsBytes();

      if (imageBytes.isEmpty) {
        throw const AIServiceException(
          'Seçilen fotoğraf boş görünüyor.',
        );
      }

      final String mimeType =
          lookupMimeType(
            image.name,
            headerBytes: imageBytes.take(32).toList(),
          ) ??
          'image/jpeg';

      final String base64Image = base64Encode(imageBytes);

      final http.Response response = await http
          .post(
            _functionUrl,
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'image': base64Image,
              'mimeType': mimeType,
            }),
          )
          .timeout(const Duration(seconds: 120));

      Map<String, dynamic> responseBody;

      try {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException();
        }

        responseBody = decoded;
      } catch (_) {
        throw AIServiceException(
          'Sunucudan okunamayan bir yanıt geldi. '
          'HTTP kodu: ${response.statusCode}',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        final String message =
            responseBody['details']?.toString() ??
            responseBody['error']?.toString() ??
            'Fotoğraf analizi başarısız oldu.';

        throw AIServiceException(message);
      }

      _validateResult(responseBody);

      return _productMatcher.enrichResult(responseBody);
    } on AIServiceException {
      rethrow;
    } on http.ClientException catch (error) {
      throw AIServiceException(
        'Sunucu bağlantısı kurulamadı: ${error.message}',
      );
    } catch (error) {
      throw AIServiceException(
        'Analiz sırasında beklenmeyen hata oluştu: $error',
      );
    }
  }

  void _validateResult(Map<String, dynamic> result) {
    const requiredFields = [
      'skinTone',
      'undertone',
      'skinType',
      'faceShape',
      'eyeColor',
      'hairColor',
      'foundationBrand',
      'foundationCode',
      'concealerBrand',
      'concealerCode',
      'blushBrand',
      'blushCode',
      'lipstickBrand',
      'lipstickCode',
      'hairStyle',
      'hairColorSuggestion',
      'disclaimer',
    ];

    for (final field in requiredFields) {
      if (!result.containsKey(field)) {
        throw AIServiceException(
          'Analiz sonucunda eksik alan bulundu: $field',
        );
      }
    }
  }
}

class AIServiceException implements Exception {
  final String message;

  const AIServiceException(this.message);

  @override
  String toString() => message;
}
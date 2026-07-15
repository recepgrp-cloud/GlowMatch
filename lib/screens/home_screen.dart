import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';
import '../services/image_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageService _imageService = ImageService();
  final AIService _aiService = AIService();

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  Future<void> _pickFromCamera() async {
    final image = await _imageService.pickFromCamera();
    await _setSelectedImage(image);
  }

  Future<void> _pickFromGallery() async {
    final image = await _imageService.pickFromGallery();
    await _setSelectedImage(image);
  }

  Future<void> _setSelectedImage(XFile? image) async {
    if (image == null) return;

    try {
      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;

      _showMessage('Fotoğraf okunamadı.');
    }
  }

  Future<void> _analyzeImage() async {
    final image = _selectedImage;

    if (image == null || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _aiService.analyzeFace(image);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } on AIServiceException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      _showMessage('Beklenmeyen hata oluştu: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('GlowMatch AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.deepPurple.shade100,
                ),
              ),
              child: _selectedImageBytes == null
                  ? const Icon(
                      Icons.face_retouching_natural,
                      size: 120,
                      color: Colors.deepPurple,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.memory(
                        _selectedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _pickFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Fotoğraf Çek'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeriden Seç'),
              ),
            ),
            const SizedBox(height: 25),
            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _analyzeImage,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(
                    _isLoading ? 'Analiz Ediliyor...' : 'AI Analiz Et',
                  ),
                ),
              ),
            const SizedBox(height: 30),
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 15),
              const Text(
                'GlowMatch AI fotoğrafını analiz ediyor...',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
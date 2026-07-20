import 'package:url_launcher/url_launcher.dart';

class ProductLinkService {
  const ProductLinkService._();

  static String _buildSearchText({
    required String brand,
    required String product,
    required String shade,
  }) {
    return [
      brand.trim(),
      product.trim(),
      shade.trim(),
    ].where((value) => value.isNotEmpty).join(' ');
  }

  static Uri _googleSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.google.com',
      '/search',
      {
        'q': '$searchText satın al',
      },
    );
  }

  static Uri _trendyolSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.trendyol.com',
      '/sr',
      {
        'q': searchText,
      },
    );
  }

  static Uri _gratisSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.google.com',
      '/search',
      {
        'q': 'site:gratis.com $searchText',
      },
    );
  }

  static Uri _watsonsSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.google.com',
      '/search',
      {
        'q': 'site:watsons.com.tr $searchText',
      },
    );
  }

  static Uri _sephoraSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.google.com',
      '/search',
      {
        'q': 'site:sephora.com.tr $searchText',
      },
    );
  }

  static Uri _boynerSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.google.com',
      '/search',
      {
        'q': 'site:boyner.com.tr $searchText',
      },
    );
  }

  static Uri _amazonSearchUri({
    required String brand,
    required String product,
    required String shade,
  }) {
    final searchText = _buildSearchText(
      brand: brand,
      product: product,
      shade: shade,
    );

    return Uri.https(
      'www.amazon.com.tr',
      '/s',
      {
        'k': searchText,
      },
    );
  }

  static Uri buildStoreUri({
    required String store,
    required String brand,
    required String product,
    required String shade,
    String? directLink,
  }) {
    if (directLink != null &&
        directLink.trim().isNotEmpty) {
      final directUri = Uri.tryParse(
        directLink.trim(),
      );

      if (directUri != null) {
        return directUri;
      }
    }

    switch (store.toLowerCase()) {
      case 'trendyol':
        return _trendyolSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'gratis':
        return _gratisSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'watsons':
        return _watsonsSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'sephora':
        return _sephoraSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'boyner':
        return _boynerSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'amazon':
        return _amazonSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );

      case 'google':
      default:
        return _googleSearchUri(
          brand: brand,
          product: product,
          shade: shade,
        );
    }
  }

  static Future<bool> openStore({
    required String store,
    required String brand,
    required String product,
    required String shade,
    String? directLink,
  }) async {
    final uri = buildStoreUri(
      store: store,
      brand: brand,
      product: product,
      shade: shade,
      directLink: directLink,
    );

    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openGoogle({
    required String brand,
    required String product,
    required String shade,
  }) {
    return openStore(
      store: 'google',
      brand: brand,
      product: product,
      shade: shade,
    );
  }

  static Future<bool> openTrendyol({
    required String brand,
    required String product,
    required String shade,
  }) {
    return openStore(
      store: 'trendyol',
      brand: brand,
      product: product,
      shade: shade,
    );
  }

  static Future<bool> openGratis({
    required String brand,
    required String product,
    required String shade,
  }) {
    return openStore(
      store: 'gratis',
      brand: brand,
      product: product,
      shade: shade,
    );
  }

  static Future<bool> openWatsons({
    required String brand,
    required String product,
    required String shade,
  }) {
    return openStore(
      store: 'watsons',
      brand: brand,
      product: product,
      shade: shade,
    );
  }
}
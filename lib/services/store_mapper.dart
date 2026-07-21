import '../data/catalog/makeup_product.dart';

class StoreResolution {
  final List<ProductStore> stores;
  final Map<ProductStore, String> directLinks;

  const StoreResolution({required this.stores, this.directLinks = const {}});
}

class StoreMapper {
  const StoreMapper._();

  static StoreResolution resolve({
    required String brand,
    required String product,
    required String shade,
  }) {
    final normalizedBrand = _normalize(brand);
    final normalizedProduct = _normalize(product);
    final normalizedShade = _normalize(shade);

    // ============================================================
    // MAC
    // ============================================================

    if (_brandMatches(normalizedBrand, const ['mac', 'm a c']) &&
        normalizedProduct.contains('studio fix fluid')) {
      return const StoreResolution(
        stores: [ProductStore.official, ProductStore.trendyol],
        directLinks: {
          ProductStore.official:
              'https://www.maccosmetics.com.tr/product/13847/94351/urunler/makyaj/yuz/fondoten/studio-fix-fluid-fondoten-15ml-mini-mac',
        },
      );
    }

    // ============================================================
    // RARE BEAUTY
    // ============================================================

    if (normalizedBrand == 'rare beauty' &&
        normalizedProduct.contains('soft pinch') &&
        normalizedProduct.contains('blush')) {
      return StoreResolution(
        stores: const [ProductStore.sephora, ProductStore.trendyol],
        directLinks: {
          ProductStore.sephora: _rareBeautyBlushLink(normalizedShade),
        },
      );
    }

    // Katalogdaki ürün adı Türkçe veya farklı yazılmışsa
    // ikinci kontrol devreye girer.
    if (normalizedBrand == 'rare beauty' &&
        normalizedProduct.contains('soft pinch')) {
      return StoreResolution(
        stores: const [ProductStore.sephora, ProductStore.trendyol],
        directLinks: {
          ProductStore.sephora: _rareBeautyBlushLink(normalizedShade),
        },
      );
    }

    // ============================================================
    // BENEFIT
    // ============================================================

    if (_brandMatches(normalizedBrand, const [
          'benefit',
          'benefit cosmetics',
        ]) &&
        (normalizedProduct.contains('cheek powder') ||
            normalizedProduct.contains('shellie')) &&
        normalizedShade.contains('shellie')) {
      return const StoreResolution(
        stores: [ProductStore.sephora, ProductStore.trendyol],
        directLinks: {
          ProductStore.sephora:
              'https://www.sephora.com.tr/p/shellie---mercan-ve-pembe-tonlarinda-allik-585603.html',
        },
      );
    }

    if (_brandMatches(normalizedBrand, const [
      'benefit',
      'benefit cosmetics',
    ])) {
      return const StoreResolution(
        stores: [ProductStore.sephora, ProductStore.trendyol],
      );
    }

    // ============================================================
    // GOLDEN ROSE
    // ============================================================

    if (normalizedBrand == 'golden rose' &&
        normalizedProduct.contains('velvet matte') &&
        _shadeMatches(normalizedShade, const ['02', 'no 02', 'no: 02'])) {
      return const StoreResolution(
        stores: [ProductStore.watsons, ProductStore.trendyol],
        directLinks: {
          ProductStore.watsons:
              'https://www.watsons.com.tr/golden-rose-velvet-mat-ruj-no-02/p/BP_141000',
        },
      );
    }

    if (normalizedBrand == 'golden rose') {
      return const StoreResolution(
        stores: [ProductStore.watsons, ProductStore.trendyol],
      );
    }

    // ============================================================
    // MAYBELLINE
    // ============================================================

    if (_brandMatches(normalizedBrand, const [
      'maybelline',
      'maybelline new york',
    ])) {
      return const StoreResolution(
        stores: [
          ProductStore.trendyol,
          ProductStore.gratis,
          ProductStore.watsons,
        ],
      );
    }

    // ============================================================
    // L'ORÉAL PARIS
    // ============================================================

    if (_brandMatches(normalizedBrand, const [
      'loreal paris',
      'l oreal paris',
    ])) {
      return const StoreResolution(
        stores: [
          ProductStore.trendyol,
          ProductStore.gratis,
          ProductStore.watsons,
        ],
      );
    }

    // ============================================================
    // FLORMAR
    // ============================================================

    if (normalizedBrand == 'flormar') {
      return const StoreResolution(
        stores: [
          ProductStore.trendyol,
          ProductStore.gratis,
          ProductStore.watsons,
        ],
      );
    }

    // ============================================================
    // NYX
    // ============================================================

    if (_brandMatches(normalizedBrand, const [
      'nyx',
      'nyx professional makeup',
    ])) {
      return const StoreResolution(
        stores: [ProductStore.trendyol, ProductStore.watsons],
      );
    }

    // ============================================================
    // NARS
    // ============================================================

    if (normalizedBrand == 'nars') {
      return const StoreResolution(
        stores: [ProductStore.sephora, ProductStore.trendyol],
      );
    }

    // ============================================================
    // FENTY BEAUTY
    // ============================================================

    if (normalizedBrand == 'fenty beauty') {
      return const StoreResolution(
        stores: [ProductStore.sephora, ProductStore.trendyol],
      );
    }

    // ============================================================
    // HUDA BEAUTY
    // ============================================================

    if (normalizedBrand == 'huda beauty') {
      return const StoreResolution(
        stores: [ProductStore.sephora, ProductStore.trendyol],
      );
    }

    // ============================================================
    // ESSENCE / CATRICE / WET N WILD
    // ============================================================

    if (normalizedBrand == 'essence') {
      return const StoreResolution(
        stores: [
          ProductStore.trendyol,
          ProductStore.gratis,
          ProductStore.watsons,
        ],
      );
    }

    if (normalizedBrand == 'catrice') {
      return const StoreResolution(
        stores: [ProductStore.trendyol, ProductStore.gratis],
      );
    }

    if (normalizedBrand == 'wet n wild') {
      return const StoreResolution(
        stores: [
          ProductStore.trendyol,
          ProductStore.gratis,
          ProductStore.watsons,
        ],
      );
    }

    // ============================================================
    // GÜVENLİ VARSAYILAN SONUÇ
    // ============================================================
    //
    // Mağazası doğrulanmamış üründe yalnızca Trendyol gösterilir.
    // ResultScreen zaten ayrıca Google'da Ara seçeneğini ekliyor.

    return const StoreResolution(stores: [ProductStore.trendyol]);
  }

  static String _rareBeautyBlushLink(String normalizedShade) {
    if (normalizedShade.contains('hope')) {
      return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-577234.html';
    }

    if (normalizedShade.contains('virtue')) {
      return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-651745.html';
    }

    if (normalizedShade.contains('grace')) {
      return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-527975.html';
    }

    if (normalizedShade.contains('grateful')) {
      return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-527974.html';
    }

    if (normalizedShade.contains('encourage')) {
      return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-577236.html';
    }

    // Diğer renklerde ürün ailesinin Sephora sayfası.
    return 'https://www.sephora.com.tr/p/soft-pinch---likit-allik-792445.html';
  }

  static bool _brandMatches(String normalizedBrand, List<String> values) {
    return values.contains(normalizedBrand);
  }

  static bool _shadeMatches(String normalizedShade, List<String> values) {
    for (final value in values) {
      if (normalizedShade == value || normalizedShade.contains(value)) {
        return true;
      }
    }

    return false;
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll('â', 'a')
        .replaceAll('î', 'i')
        .replaceAll('û', 'u')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('’', '')
        .replaceAll('‘', '')
        .replaceAll('\'', '')
        .replaceAll('·', ' ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

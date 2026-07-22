import '../data/catalog/makeup_product.dart';

class StoreResolution {
  final List<ProductStore> stores;
  final Map<ProductStore, String> directLinks;

  const StoreResolution({this.stores = const [], this.directLinks = const {}});
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

    final directLinks = <ProductStore, String>{};

    // ============================================================
    // RARE BEAUTY - SOFT PINCH
    // Yalnızca doğrulanmış renk ve ürün bağlantıları gösterilir.
    // ============================================================

    final isRareBeautySoftPinch =
        normalizedBrand == 'rare beauty' &&
        normalizedProduct.contains('soft pinch');

    if (isRareBeautySoftPinch) {
      if (_containsAny(normalizedShade, const ['hope'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-577234.html';
      } else if (_containsAny(normalizedShade, const ['virtue'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-651745.html';
      } else if (_containsAny(normalizedShade, const ['encourage'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-577236.html';
      } else if (_containsAny(normalizedShade, const ['grateful'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-527974.html';
      } else if (_containsAny(normalizedShade, const ['love'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-527978.html';
      } else if (_containsAny(normalizedShade, const ['adore'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-792445.html';
      } else if (_containsAny(normalizedShade, const ['spirited'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-792446.html';
      } else if (_containsAny(normalizedShade, const ['resilience'])) {
        directLinks[ProductStore.sephora] =
            'https://www.sephora.com.tr/p/soft-pinch---likit-allik-792231.html';
      }
    }

    // ============================================================
    // GÜVENLİ SONUÇ
    // ============================================================
    //
    // Mağaza listesi yalnızca gerçek doğrudan bağlantısı bulunan
    // mağazalardan oluşturulur.
    //
    // Doğrudan bağlantı yoksa boş liste döner.
    // ResultScreen yine Google'da Ara seçeneğini gösterecektir.

    return StoreResolution(
      stores: directLinks.keys.toList(),
      directLinks: directLinks,
    );
  }

  static bool _containsAny(String normalizedValue, List<String> candidates) {
    for (final candidate in candidates) {
      if (normalizedValue.contains(candidate)) {
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

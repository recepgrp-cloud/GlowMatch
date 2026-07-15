import '../data/product_catalog.dart';

class ProductMatcher {
  Map<String, dynamic> enrichResult(Map<String, dynamic> result) {
    // Önce fondöten seçilir.
    // Kapatıcı seçimi ana fondötene göre yapılacaktır.
    final foundations = _findTopProducts(
      category: 'foundation',
      result: result,
      preferPriceDiversity: true,
    );

    final MakeupProduct? selectedFoundation =
        foundations.isNotEmpty ? foundations.first : null;

    final concealers = _findTopProducts(
      category: 'concealer',
      result: result,
      referenceFoundation: selectedFoundation,
      preferPriceDiversity: true,
    );

    final blushes = _findTopProducts(
      category: 'blush',
      result: result,
      preferPriceDiversity: true,
    );

    final lipsticks = _findTopProducts(
      category: 'lipstick',
      result: result,
      preferPriceDiversity: true,
    );

    return {
      ...result,
      if (foundations.isNotEmpty) ...{
        'foundationBrand':
            '${foundations.first.brand} — ${foundations.first.product}',
        'foundationCode': foundations.first.shade,
        'foundationRecommendations':
            foundations.map(_productToMap).toList(),
      },
      if (concealers.isNotEmpty) ...{
        'concealerBrand':
            '${concealers.first.brand} — ${concealers.first.product}',
        'concealerCode': concealers.first.shade,
        'concealerRecommendations':
            concealers.map(_productToMap).toList(),
      },
      if (blushes.isNotEmpty) ...{
        'blushBrand':
            '${blushes.first.brand} — ${blushes.first.product}',
        'blushCode': blushes.first.shade,
        'blushRecommendations':
            blushes.map(_productToMap).toList(),
      },
      if (lipsticks.isNotEmpty) ...{
        'lipstickBrand':
            '${lipsticks.first.brand} — ${lipsticks.first.product}',
        'lipstickCode': lipsticks.first.shade,
        'lipstickRecommendations':
            lipsticks.map(_productToMap).toList(),
      },
    };
  }

  Map<String, dynamic> _productToMap(MakeupProduct product) {
    return {
      'brand': product.brand,
      'product': product.product,
      'shade': product.shade,
      'priceLevel': product.priceLevel,
      'averagePrice': product.averagePrice,
      'finish': product.finish,
      'vegan': product.vegan,
      'crueltyFree': product.crueltyFree,
    };
  }

  List<MakeupProduct> _findTopProducts({
    required String category,
    required Map<String, dynamic> result,
    MakeupProduct? referenceFoundation,
    bool preferPriceDiversity = false,
    int limit = 3,
  }) {
    final products = ProductCatalog.products
        .where((product) => product.category == category)
        .toList();

    if (products.isEmpty) {
      return [];
    }

    final sourceText = _normalize(
      [
        result['skinTone'],
        result['undertone'],
        result['foundationBrand'],
        result['foundationCode'],
        result['concealerBrand'],
        result['concealerCode'],
        result['blushBrand'],
        result['blushCode'],
        result['lipstickBrand'],
        result['lipstickCode'],
      ].whereType<Object>().join(' '),
    );

    final detectedUndertone = _detectUndertone(
      result['undertone']?.toString() ?? '',
    );

    final detectedSkinTone = _detectSkinTone(
      result['skinTone']?.toString() ?? '',
    );

    final scoredProducts = products.map((product) {
      int score = 0;

      if (product.undertones.contains(detectedUndertone)) {
        score += 10;
      }

      if (product.skinTones.contains(detectedSkinTone)) {
        score += 8;
      }

      for (final tag in product.colorTags) {
        final normalizedTag = _normalize(tag);

        if (normalizedTag.isNotEmpty &&
            sourceText.contains(normalizedTag)) {
          score += 4;
        }
      }

      if (category == 'foundation') {
        score += _foundationShadeScore(
          product: product,
          detectedSkinTone: detectedSkinTone,
          detectedUndertone: detectedUndertone,
        );
      }

      if (category == 'concealer') {
        score += _concealerShadeScore(
          product: product,
          detectedSkinTone: detectedSkinTone,
          detectedUndertone: detectedUndertone,
          referenceFoundation: referenceFoundation,
        );
      }

      return _ScoredProduct(
        product: product,
        score: score,
      );
    }).toList();

    scoredProducts.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.product.shade.compareTo(b.product.shade);
    });

    return _takeDiverseProducts(
      scoredProducts: scoredProducts,
      limit: limit,
      preferPriceDiversity: preferPriceDiversity,
    );
  }

  int _foundationShadeScore({
    required MakeupProduct product,
    required String detectedSkinTone,
    required String detectedUndertone,
  }) {
    final productDepth = _foundationDepth(product);
    final targetDepth = _skinToneDepth(detectedSkinTone);

    int score = 0;

    if (productDepth != null) {
      final distance = (productDepth - targetDepth).abs();

      if (distance == 0) {
        score += 24;
      } else if (distance == 1) {
        score += 10;
      } else if (distance == 2) {
        score -= 15;
      } else {
        score -= 30;
      }

      // Fondötenin hedef tenden daha koyu olması biraz daha risklidir.
      if (productDepth > targetDepth) {
        final darkerDistance = productDepth - targetDepth;

        if (darkerDistance == 1) {
          score -= 4;
        } else if (darkerDistance >= 2) {
          score -= 12;
        }
      }
    }

    if (detectedUndertone == 'warm') {
      if (product.undertones.contains('warm')) {
        score += 7;
      }

      if (product.undertones.contains('cool') &&
          !product.undertones.contains('neutral')) {
        score -= 7;
      }
    }

    if (detectedUndertone == 'cool') {
      if (product.undertones.contains('cool')) {
        score += 7;
      }

      if (product.undertones.contains('warm') &&
          !product.undertones.contains('neutral')) {
        score -= 7;
      }
    }

    if (detectedUndertone == 'neutral') {
      if (product.undertones.contains('neutral')) {
        score += 7;
      }
    }

    return score;
  }

  int _concealerShadeScore({
    required MakeupProduct product,
    required String detectedSkinTone,
    required String detectedUndertone,
    MakeupProduct? referenceFoundation,
  }) {
    final shade = _normalize(product.shade);

    int score = 0;

    if (detectedSkinTone == 'light') {
      if (shade.contains('10 light')) score += 15;
      if (shade.contains('15 fair')) score += 13;
      if (shade.contains('20 sand')) score += 9;
      if (shade.contains('n1')) score += 11;
      if (shade.contains('w2')) score += 8;

      if (shade.contains('25 medium') ||
          shade.contains('30 honey') ||
          shade.contains('n5')) {
        score -= 14;
      }
    }

    if (detectedSkinTone == 'lightMedium') {
      if (shade.contains('20 sand')) score += 18;
      if (shade.contains('10 light')) score += 12;
      if (shade.contains('15 fair')) score += 10;
      if (shade.contains('n3')) score += 14;
      if (shade.contains('w2')) score += 12;
      if (shade.contains('25 medium')) score += 5;

      if (shade.contains('30 honey') ||
          shade.contains('n5') ||
          shade.contains('w7')) {
        score -= 12;
      }
    }

    if (detectedSkinTone == 'medium') {
      if (shade.contains('25 medium')) score += 16;
      if (shade.contains('20 sand')) score += 10;
      if (shade.contains('30 honey')) score += 12;
      if (shade.contains('w4')) score += 12;
      if (shade.contains('n5')) score += 9;

      if (shade.contains('10 light') ||
          shade.contains('15 fair')) {
        score -= 9;
      }
    }

    if (detectedSkinTone == 'mediumDeep') {
      if (shade.contains('35 deep')) score += 15;
      if (shade.contains('40 caramel')) score += 14;
      if (shade.contains('w7')) score += 12;
      if (shade.contains('30 honey')) score += 9;

      if (shade.contains('10 light') ||
          shade.contains('15 fair') ||
          shade.contains('20 sand')) {
        score -= 12;
      }
    }

    if (detectedSkinTone == 'deep') {
      if (shade.contains('50 cafe')) score += 16;
      if (shade.contains('40 caramel')) score += 14;
      if (shade.contains('35 deep')) score += 10;

      if (shade.contains('10 light') ||
          shade.contains('15 fair') ||
          shade.contains('20 sand')) {
        score -= 15;
      }
    }

    if (detectedUndertone == 'cool') {
      if (product.undertones.contains('cool')) {
        score += 5;
      }

      if (product.undertones.contains('warm') &&
          !product.undertones.contains('neutral')) {
        score -= 4;
      }
    }

    if (detectedUndertone == 'warm') {
      if (product.undertones.contains('warm')) {
        score += 5;
      }

      if (product.undertones.contains('cool') &&
          !product.undertones.contains('neutral')) {
        score -= 4;
      }
    }

    if (detectedUndertone == 'neutral' &&
        product.undertones.contains('neutral')) {
      score += 5;
    }

    if (referenceFoundation != null) {
      score += _foundationConcealerRelationScore(
        foundation: referenceFoundation,
        concealer: product,
      );
    }

    return score;
  }

  int _foundationConcealerRelationScore({
    required MakeupProduct foundation,
    required MakeupProduct concealer,
  }) {
    final foundationDepth = _foundationDepth(foundation);
    final concealerDepth = _concealerDepth(concealer);

    if (foundationDepth == null || concealerDepth == null) {
      return 0;
    }

    final difference = concealerDepth - foundationDepth;

    // Aynı derinlik
    if (difference == 0) {
      return 18;
    }

    // Bir ton açık, kapatıcı için genellikle en uygun seçenek
    if (difference == -1) {
      return 22;
    }

    // İki ton açık, aydınlatıcı alternatif
    if (difference == -2) {
      return 8;
    }

    // Fondötenden bir ton koyu
    if (difference == 1) {
      return -10;
    }

    // Fondötenden iki veya daha fazla ton koyu
    if (difference >= 2) {
      return -22;
    }

    // Fazla açık
    if (difference <= -3) {
      return -12;
    }

    return 0;
  }

  int _skinToneDepth(String skinTone) {
    switch (skinTone) {
      case 'light':
        return 1;
      case 'lightMedium':
        return 2;
      case 'medium':
        return 3;
      case 'mediumDeep':
        return 4;
      case 'deep':
        return 5;
      default:
        return 2;
    }
  }

  int? _foundationDepth(MakeupProduct product) {
    final text = _normalize(
      '${product.brand} ${product.product} ${product.shade}',
    );

    // Çok açık ve açık tonlar
    if (_containsAny(text, [
      'c1',
      'n1',
      'w1',
      '101 pastelle',
      '02 ivory',
      '401',
      '01 beige',
      'soft ivory',
      'nude ivory',
      '002 porcelain beige',
      '010 light beige',
    ])) {
      return 1;
    }

    // Açık-orta tonlar
    if (_containsAny(text, [
      '118',
      '120',
      '125',
      '128',
      'n2',
      'w2.5',
      'w3',
      'n3',
      'c3',
      '102 soft beige',
      '103 natural beige',
      '03 nude',
      '04 natural beige',
      '402',
      '403',
      '02 natural beige',
      '03 medium beige',
      'soft beige',
      '020 rose beige',
      '030 sand beige',
    ])) {
      return 2;
    }

    // Orta tonlar
    if (_containsAny(text, [
      '220',
      '230',
      '310',
      'w4',
      'n4',
      'w5',
      'n5',
      'c5',
      '104 golden beige',
      '105 honey beige',
      '05 beige',
      '06 honey',
      '404',
      '04 sand',
      '05 honey beige',
      'golden beige',
      '040 warm beige',
    ])) {
      return 3;
    }

    // Orta-koyu tonlar
    if (_containsAny(text, [
      '334',
      'w7',
      'n7',
      'c7',
      'medium deep',
      'mediumdeep',
    ])) {
      return 4;
    }

    // Koyu tonlar
    if (_containsAny(text, [
      '355',
      'deep',
      'dark',
    ])) {
      return 5;
    }

    // Kod belirlenemezse katalogdaki skinTones kullanılır.
    if (product.skinTones.contains('light')) {
      return 1;
    }

    if (product.skinTones.contains('lightMedium')) {
      return 2;
    }

    if (product.skinTones.contains('medium')) {
      return 3;
    }

    if (product.skinTones.contains('mediumDeep')) {
      return 4;
    }

    if (product.skinTones.contains('deep')) {
      return 5;
    }

    return null;
  }

  int? _concealerDepth(MakeupProduct product) {
    final text = _normalize(
      '${product.brand} ${product.product} ${product.shade}',
    );

    if (_containsAny(text, [
      '05 ivory',
      '10 light',
      '15 fair',
      'n1',
      'c1',
      'ivory',
      'porcelain',
    ])) {
      return 1;
    }

    if (_containsAny(text, [
      '20 sand',
      'w2',
      'n2',
      'c2',
      'light beige',
      'natural beige',
    ])) {
      return 2;
    }

    if (_containsAny(text, [
      '25 medium',
      'n3',
      'w3',
      'c3',
      'medium beige',
    ])) {
      return 3;
    }

    if (_containsAny(text, [
      '30 honey',
      'w4',
      'n4',
      'n5',
      'honey',
      'golden',
    ])) {
      return 4;
    }

    if (_containsAny(text, [
      '35 deep',
      '40 caramel',
      '50 cafe',
      'w7',
      'n7',
      'deep',
      'dark',
      'caramel',
      'cafe',
    ])) {
      return 5;
    }

    if (product.skinTones.contains('light')) {
      return 1;
    }

    if (product.skinTones.contains('lightMedium')) {
      return 2;
    }

    if (product.skinTones.contains('medium')) {
      return 3;
    }

    if (product.skinTones.contains('mediumDeep')) {
      return 4;
    }

    if (product.skinTones.contains('deep')) {
      return 5;
    }

    return null;
  }

  List<MakeupProduct> _takeDiverseProducts({
    required List<_ScoredProduct> scoredProducts,
    required int limit,
    required bool preferPriceDiversity,
  }) {
    if (scoredProducts.isEmpty) {
      return [];
    }

    final selected = <MakeupProduct>[];
    final usedBrands = <String>{};
    final usedPriceLevels = <int>{};

    final bestScore = scoredProducts.first.score;

    bool isAlreadySelected(MakeupProduct product) {
      return selected.any(
        (selectedProduct) =>
            selectedProduct.brand == product.brand &&
            selectedProduct.product == product.product &&
            selectedProduct.shade == product.shade,
      );
    }

    void addProduct(MakeupProduct product) {
      selected.add(product);
      usedBrands.add(_normalize(product.brand));
      usedPriceLevels.add(product.priceLevel);
    }

    // Birinci ürün her zaman en yüksek puanlı eşleşmedir.
    addProduct(scoredProducts.first.product);

    // Farklı marka ve farklı fiyat seviyesi bul.
    if (preferPriceDiversity) {
      for (final item in scoredProducts.skip(1)) {
        if (selected.length >= limit) {
          break;
        }

        final product = item.product;
        final normalizedBrand = _normalize(product.brand);

        final closeEnough = item.score >= bestScore - 14;
        final newBrand = !usedBrands.contains(normalizedBrand);
        final newPriceLevel =
            !usedPriceLevels.contains(product.priceLevel);

        if (closeEnough && newBrand && newPriceLevel) {
          addProduct(product);
        }
      }
    }

    // Farklı markalarla tamamla.
    for (final item in scoredProducts.skip(1)) {
      if (selected.length >= limit) {
        break;
      }

      final product = item.product;
      final normalizedBrand = _normalize(product.brand);

      final closeEnough = item.score >= bestScore - 18;
      final newBrand = !usedBrands.contains(normalizedBrand);

      if (closeEnough &&
          newBrand &&
          !isAlreadySelected(product)) {
        addProduct(product);
      }
    }

    // Yakın tonlu kalan ürünlerle tamamla.
    for (final item in scoredProducts.skip(1)) {
      if (selected.length >= limit) {
        break;
      }

      final product = item.product;
      final closeEnough = item.score >= bestScore - 20;

      if (closeEnough && !isAlreadySelected(product)) {
        addProduct(product);
      }
    }

    // Katalog küçükse son çare olarak kalan ürünleri ekle.
    if (selected.length < limit) {
      for (final item in scoredProducts.skip(1)) {
        if (selected.length >= limit) {
          break;
        }

        if (!isAlreadySelected(item.product)) {
          addProduct(item.product);
        }
      }
    }

    return selected;
  }

  String _detectUndertone(String value) {
    final normalized = _normalize(value);

    if (normalized.contains('notr') &&
        normalized.contains('soguk')) {
      return 'cool';
    }

    if (normalized.contains('notr') &&
        normalized.contains('sicak')) {
      return 'warm';
    }

    if (normalized.contains('soguk') ||
        normalized.contains('cool') ||
        normalized.contains('pembe')) {
      return 'cool';
    }

    if (normalized.contains('sicak') ||
        normalized.contains('warm') ||
        normalized.contains('sari') ||
        normalized.contains('altin') ||
        normalized.contains('zeytin')) {
      return 'warm';
    }

    return 'neutral';
  }

  String _detectSkinTone(String value) {
    final normalized = _normalize(value);

    if (normalized.contains('cok koyu') ||
        normalized.contains('deep')) {
      return 'deep';
    }

    if (normalized.contains('orta koyu') ||
        normalized.contains('medium deep')) {
      return 'mediumDeep';
    }

    if (normalized.contains('acik-orta') ||
        normalized.contains('acik orta') ||
        normalized.contains('acik ile acik-orta') ||
        normalized.contains('acik ile acik orta') ||
        normalized.contains('acik bugday') ||
        normalized.contains('light medium') ||
        normalized.contains('light-medium')) {
      return 'lightMedium';
    }

    if (normalized.contains('bugday') ||
        normalized.contains('orta') ||
        normalized.contains('medium')) {
      return 'medium';
    }

    if (normalized.contains('acik') ||
        normalized.contains('light') ||
        normalized.contains('fair')) {
      return 'light';
    }

    if (normalized.contains('koyu')) {
      return 'mediumDeep';
    }

    return 'lightMedium';
  }

  bool _containsAny(String text, List<String> values) {
    return values.any(
      (value) => text.contains(_normalize(value)),
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll('â', 'a')
        .trim();
  }
}

class _ScoredProduct {
  final MakeupProduct product;
  final int score;

  const _ScoredProduct({
    required this.product,
    required this.score,
  });
}
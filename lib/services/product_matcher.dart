import 'store_mapper.dart';
import '../data/product_catalog.dart';

class ProductMatcher {
  Map<String, dynamic> enrichResult(Map<String, dynamic> result) {
    final detectedSkinTone = _detectSkinTone(
      result['skinTone']?.toString() ?? '',
    );

    final detectedUndertone = _detectUndertone(
      result['undertone']?.toString() ?? '',
    );

    final detectedSkinType = result['skinType']?.toString() ?? '';

    final shadeFamily = _buildShadeFamily(
      skinTone: detectedSkinTone,
      undertone: detectedUndertone,
    );

    final foundations = _findShadeFamilyProducts(
      category: 'foundation',
      shadeFamily: shadeFamily,
      skinTone: detectedSkinTone,
      undertone: detectedUndertone,
      skinType: detectedSkinType,
    );

    final selectedFoundation = foundations.isNotEmpty
        ? foundations.first
        : null;

    final affordableFoundations = selectedFoundation != null
        ? _findAffordableAlternatives(
            referenceProduct: selectedFoundation,
            category: 'foundation',
            skinTone: detectedSkinTone,
            undertone: detectedUndertone,
            skinType: detectedSkinType,
          )
        : <MakeupProduct>[];

    final concealers = _findConcealers(
      skinTone: detectedSkinTone,
      undertone: detectedUndertone,
      skinType: detectedSkinType,
      foundation: selectedFoundation,
    );

    final blushes = _findGeneralProducts(
      category: 'blush',
      result: result,
      detectedSkinTone: detectedSkinTone,
      detectedUndertone: detectedUndertone,
      detectedSkinType: detectedSkinType,
    );

    final lipsticks = _findGeneralProducts(
      category: 'lipstick',
      result: result,
      detectedSkinTone: detectedSkinTone,
      detectedUndertone: detectedUndertone,
      detectedSkinType: detectedSkinType,
    );

    return {
      ...result,
      'shadeFamily': shadeFamily,
      'shadeFamilyLabel': _shadeFamilyLabel(shadeFamily),

      if (foundations.isNotEmpty) ...{
        'foundationBrand':
            '${foundations.first.brand} — ${foundations.first.product}',
        'foundationCode': foundations.first.shade,
        'foundationRecommendations': foundations
            .map(
              (product) => _productToMap(
                product,
                skinTone: detectedSkinTone,
                undertone: detectedUndertone,
                skinType: detectedSkinType,
              ),
            )
            .toList(),
        'affordableFoundationAlternatives': affordableFoundations
            .map(
              (product) => _productToMap(
                product,
                skinTone: detectedSkinTone,
                undertone: detectedUndertone,
                skinType: detectedSkinType,
              ),
            )
            .toList(),
      },

      if (concealers.isNotEmpty) ...{
        'concealerBrand':
            '${concealers.first.brand} — ${concealers.first.product}',
        'concealerCode': concealers.first.shade,
        'concealerRecommendations': concealers
            .map(
              (product) => _productToMap(
                product,
                skinTone: detectedSkinTone,
                undertone: detectedUndertone,
                skinType: detectedSkinType,
              ),
            )
            .toList(),
      },

      if (blushes.isNotEmpty) ...{
        'blushBrand': '${blushes.first.brand} — ${blushes.first.product}',
        'blushCode': blushes.first.shade,
        'blushRecommendations': blushes
            .map(
              (product) => _productToMap(
                product,
                skinTone: detectedSkinTone,
                undertone: detectedUndertone,
                skinType: detectedSkinType,
              ),
            )
            .toList(),
      },

      if (lipsticks.isNotEmpty) ...{
        'lipstickBrand':
            '${lipsticks.first.brand} — ${lipsticks.first.product}',
        'lipstickCode': lipsticks.first.shade,
        'lipstickRecommendations': lipsticks
            .map(
              (product) => _productToMap(
                product,
                skinTone: detectedSkinTone,
                undertone: detectedUndertone,
                skinType: detectedSkinType,
              ),
            )
            .toList(),
      },
    };
  }

  Map<String, dynamic> _productToMap(
    MakeupProduct product, {
    required String skinTone,
    required String undertone,
    required String skinType,
  }) {
    final match = _calculateProductMatch(
      product: product,
      skinTone: skinTone,
      undertone: undertone,
      skinType: skinType,
    );

    final storeResolution = StoreMapper.resolve(
      brand: product.brand,
      product: product.product,
      shade: product.shade,
    );

    final resolvedStores = <ProductStore>{
      ...storeResolution.stores,
      ...product.stores,
      ...storeResolution.directLinks.keys,
      ...product.storeLinks.keys,
    }.toList();

    final resolvedLinks = <ProductStore, String>{
      ...storeResolution.directLinks,
      ...product.storeLinks,
    };

    return {
      'brand': product.brand,
      'product': product.product,
      'shade': product.shade,
      'shadeFamily': product.shadeFamily,
      'priceLevel': product.priceLevel,
      'priceSegment': product.priceSegmentLabel,
      'averagePrice': product.averagePrice,
      'finish': product.finish,
      'coverage': product.coverage,
      'skinTypes': product.skinTypes,
      'vegan': product.vegan,
      'crueltyFree': product.crueltyFree,
      'matchScore': match.score,
      'matchReason': match.reason,
      'stores': resolvedStores.map((store) => store.name).toList(),
      'storeLinks': resolvedLinks.map(
        (store, link) => MapEntry(store.name, link),
      ),
    };
  }

  _ProductMatch _calculateProductMatch({
    required MakeupProduct product,
    required String skinTone,
    required String undertone,
    required String skinType,
  }) {
    int score = 18;
    final reasons = <String>[];

    final normalizedSkinType = _normalize(skinType);
    final normalizedFinish = _normalize(product.finish);
    final normalizedCoverage = _normalize(product.coverage);

    final hasReliableSkinType = _hasReliableSkinType(normalizedSkinType);

    final expectedShadeFamily = _buildShadeFamily(
      skinTone: skinTone,
      undertone: undertone,
    );

    // ------------------------------------------------------------
    // 1. TEN TONU EŞLEŞMESİ
    // ------------------------------------------------------------

    if (product.skinTones.contains(skinTone)) {
      score += 24;
      reasons.add('cilt tonunla uyumlu');

      if (product.skinTones.length == 1) {
        score += 4;
      } else if (product.skinTones.length == 2) {
        score += 2;
      }
    } else if (_isNeighbourSkinTone(
      productSkinTones: product.skinTones,
      detectedSkinTone: skinTone,
    )) {
      score += 10;
      reasons.add('yakın ten tonu ailesiyle uyum sağlayabilir');
    }

    // ------------------------------------------------------------
    // 2. ALT TON EŞLEŞMESİ
    // ------------------------------------------------------------

    if (product.undertones.contains(undertone)) {
      score += 20;
      reasons.add('alt tonunla uyumlu');

      if (product.undertones.length == 1) {
        score += 4;
      } else if (product.undertones.length == 2) {
        score += 2;
      }
    } else if (product.undertones.contains('neutral')) {
      score += 9;
      reasons.add('nötr yapısıyla alt tonuna uyum sağlayabilir');
    }

    // ------------------------------------------------------------
    // 3. TON AİLESİ EŞLEŞMESİ
    // Fondöten ve kapatıcıda daha belirleyicidir.
    // ------------------------------------------------------------

    if (product.shadeFamily.isNotEmpty) {
      if (product.shadeFamily == expectedShadeFamily) {
        score += 10;
        reasons.add('ton ailesiyle birebir eşleşiyor');
      } else if (product.shadeFamily.startsWith(skinTone)) {
        score += 4;
        reasons.add('ten tonu ailesine yakın bir renktir');
      }
    }

    // ------------------------------------------------------------
    // 4. CİLT TİPİ VE BİTİŞ UYUMU
    // Cilt tipi güvenilir biçimde belirlenmişse çalışır.
    // ------------------------------------------------------------

    if (hasReliableSkinType) {
      final skinTypeMatched = product.skinTypes.any((type) {
        final normalizedProductType = _normalize(type);

        return normalizedProductType == normalizedSkinType ||
            normalizedSkinType.contains(normalizedProductType) ||
            normalizedProductType.contains(normalizedSkinType);
      });

      if (skinTypeMatched) {
        score += 10;
        reasons.add('cilt tipine uygun');
      }

      if (normalizedSkinType.contains('yagli')) {
        if (normalizedFinish.contains('mat')) {
          score += 5;
          reasons.add('mat bitişi parlama kontrolünü destekler');
        }

        if (normalizedFinish.contains('nemli')) {
          score -= 3;
        }
      }

      if (normalizedSkinType.contains('karma')) {
        if (normalizedFinish.contains('mat') ||
            normalizedFinish.contains('dogal') ||
            normalizedFinish.contains('saten')) {
          score += 4;
          reasons.add('bitişi karma cilt için dengeli');
        }
      }

      if (normalizedSkinType.contains('kuru')) {
        if (normalizedFinish.contains('dogal') ||
            normalizedFinish.contains('isilti') ||
            normalizedFinish.contains('nemli') ||
            normalizedFinish.contains('saten') ||
            normalizedFinish.contains('parlak')) {
          score += 5;
          reasons.add('bitişi kuru cilt için daha uygundur');
        }

        if (normalizedFinish.contains('mat') &&
            !normalizedFinish.contains('dogal') &&
            !normalizedFinish.contains('yumusa')) {
          score -= 5;
        }
      }

      if (normalizedSkinType.contains('normal')) {
        if (normalizedFinish.contains('dogal') ||
            normalizedFinish.contains('saten')) {
          score += 4;
          reasons.add('bitişi normal cilt için dengeli');
        }
      }
    }

    // ------------------------------------------------------------
    // 5. ÜRÜN VERİSİNİN TAMLIĞI
    // ------------------------------------------------------------

    if (product.finish.trim().isNotEmpty) {
      score += 1;
    }

    if (product.coverage.trim().isNotEmpty) {
      score += 1;
    }

    if (product.skinTypes.isNotEmpty) {
      score += 1;
    }

    if (product.averagePrice > 0) {
      score += 1;
    }

    // ------------------------------------------------------------
    // 6. KAPATICILIK VE PİGMENT YAPISI
    // ------------------------------------------------------------

    if (normalizedCoverage.contains('katmanlanabilir')) {
      score += 2;
    }

    if (normalizedCoverage.contains('yogun pigmentli') ||
        normalizedCoverage.contains('orta-yuksek')) {
      score += 1;
    }

    // ------------------------------------------------------------
    // 7. FİYAT SEGMENTİ
    // Fiyat, uyumluluğu yükseltmez. Yalnızca açıklama üretir.
    // ------------------------------------------------------------

    switch (product.priceSegment) {
      case PriceSegment.budget:
        reasons.add('uygun fiyatlı bir alternatif');
        break;

      case PriceSegment.midRange:
        reasons.add('fiyat ve performans dengesi güçlü');
        break;

      case PriceSegment.premium:
        reasons.add('premium segment alternatifi');
        break;
    }

    // Cilt tipi bilinmiyorsa aşırı kesin puan göstermiyoruz.
    final maximumScore = hasReliableSkinType ? 97 : 94;

    final finalScore = score.clamp(0, maximumScore).toInt();

    final uniqueReasons = _uniqueReasons(reasons);

    return _ProductMatch(
      score: finalScore,
      reason: uniqueReasons.isEmpty
          ? 'genel ürün özelliklerine göre önerildi'
          : uniqueReasons.join(', '),
    );
  }

  bool _hasReliableSkinType(String normalizedSkinType) {
    if (normalizedSkinType.isEmpty) {
      return false;
    }

    const uncertainExpressions = [
      'belirlenemez',
      'guvenilir bicimde belirlenemez',
      'fotograftan belirlenemez',
      'bilinmiyor',
      'belirsiz',
      'tespit edilemedi',
      'anlasilamadi',
    ];

    for (final expression in uncertainExpressions) {
      if (normalizedSkinType.contains(expression)) {
        return false;
      }
    }

    return normalizedSkinType.contains('normal') ||
        normalizedSkinType.contains('karma') ||
        normalizedSkinType.contains('yagli') ||
        normalizedSkinType.contains('kuru') ||
        normalizedSkinType.contains('hassas');
  }

  bool _isNeighbourSkinTone({
    required List<String> productSkinTones,
    required String detectedSkinTone,
  }) {
    const toneOrder = ['light', 'lightMedium', 'medium', 'mediumDeep', 'deep'];

    final detectedIndex = toneOrder.indexOf(detectedSkinTone);

    if (detectedIndex == -1) {
      return false;
    }

    for (final productTone in productSkinTones) {
      final productIndex = toneOrder.indexOf(productTone);

      if (productIndex == -1) {
        continue;
      }

      if ((productIndex - detectedIndex).abs() == 1) {
        return true;
      }
    }

    return false;
  }

  List<String> _uniqueReasons(List<String> reasons) {
    final uniqueReasons = <String>[];
    final normalizedReasons = <String>{};

    for (final reason in reasons) {
      final normalizedReason = _normalize(reason);

      if (normalizedReason.isEmpty ||
          normalizedReasons.contains(normalizedReason)) {
        continue;
      }

      normalizedReasons.add(normalizedReason);
      uniqueReasons.add(reason);
    }

    return uniqueReasons;
  }

  int _selectionScore({
    required MakeupProduct product,
    required String skinTone,
    required String undertone,
    required String skinType,
  }) {
    return _calculateProductMatch(
      product: product,
      skinTone: skinTone,
      undertone: undertone,
      skinType: skinType,
    ).score;
  }

  List<MakeupProduct> _findShadeFamilyProducts({
    required String category,
    required String shadeFamily,
    required String skinTone,
    required String undertone,
    required String skinType,
  }) {
    final categoryProducts = ProductCatalog.products
        .where((product) => product.category == category)
        .toList();

    if (categoryProducts.isEmpty) {
      return [];
    }

    var matchingProducts = categoryProducts
        .where((product) => product.shadeFamily == shadeFamily)
        .toList();

    if (matchingProducts.isEmpty) {
      matchingProducts = categoryProducts.where((product) {
        return product.skinTones.contains(skinTone) &&
            product.undertones.contains(undertone);
      }).toList();
    }

    if (matchingProducts.isEmpty) {
      matchingProducts = categoryProducts.where((product) {
        return product.skinTones.contains(skinTone);
      }).toList();
    }

    if (matchingProducts.isEmpty) {
      matchingProducts = categoryProducts;
    }

    matchingProducts.sort((a, b) {
      final aScore = _selectionScore(
        product: a,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final bScore = _selectionScore(
        product: b,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final scoreComparison = bScore.compareTo(aScore);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.averagePrice.compareTo(b.averagePrice);
    });

    return _selectByPriceSegment(
      matchingProducts,
      skinTone,
      undertone,
      skinType,
    );
  }

  List<MakeupProduct> _selectByPriceSegment(
    List<MakeupProduct> products,
    String skinTone,
    String undertone,
    String skinType,
  ) {
    if (products.isEmpty) {
      return [];
    }

    final selected = <MakeupProduct>[];
    final usedBrands = <String>{};
    final usedSegments = <PriceSegment>{};

    // Listenin ilk ürünü en yüksek puanlı üründür.
    final bestProduct = products.first;

    selected.add(bestProduct);
    usedBrands.add(bestProduct.brand);
    usedSegments.add(bestProduct.priceSegment);

    // Önce farklı marka ve farklı fiyat segmenti seç.
    for (final product in products.skip(1)) {
      if (selected.length >= 3) {
        break;
      }

      if (!usedBrands.contains(product.brand) &&
          !usedSegments.contains(product.priceSegment)) {
        selected.add(product);
        usedBrands.add(product.brand);
        usedSegments.add(product.priceSegment);
      }
    }

    // Listeyi farklı markalarla tamamla.
    for (final product in products.skip(1)) {
      if (selected.length >= 3) {
        break;
      }

      final alreadySelected = selected.any(
        (item) =>
            item.brand == product.brand &&
            item.product == product.product &&
            item.shade == product.shade,
      );

      if (!alreadySelected && !usedBrands.contains(product.brand)) {
        selected.add(product);
        usedBrands.add(product.brand);
      }
    }

    // Yeterli farklı marka yoksa kalan yüksek puanlı ürünleri ekle.
    for (final product in products.skip(1)) {
      if (selected.length >= 3) {
        break;
      }

      final alreadySelected = selected.any(
        (item) =>
            item.brand == product.brand &&
            item.product == product.product &&
            item.shade == product.shade,
      );

      if (!alreadySelected) {
        selected.add(product);
      }
    }

    // Sonuçları tekrar uyum puanına göre sırala.
    selected.sort((a, b) {
      final aScore = _selectionScore(
        product: a,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final bScore = _selectionScore(
        product: b,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final scoreComparison = bScore.compareTo(aScore);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.averagePrice.compareTo(b.averagePrice);
    });

    return selected.take(3).toList();
  }

  List<MakeupProduct> _findConcealers({
    required String skinTone,
    required String undertone,
    required String skinType,
    MakeupProduct? foundation,
  }) {
    final products = ProductCatalog.products
        .where((product) => product.category == 'concealer')
        .toList();

    if (products.isEmpty) {
      return [];
    }

    final scoredProducts = products.map((product) {
      int score = _selectionScore(
        product: product,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      if (foundation != null) {
        if (product.shadeFamily == foundation.shadeFamily) {
          score += 25;
        }

        if (product.brand == foundation.brand) {
          score += 5;
        }

        score += _foundationConcealerRelationScore(
          foundation: foundation,
          concealer: product,
        );
      }

      return _ScoredProduct(product: product, score: score);
    }).toList();

    scoredProducts.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.product.averagePrice.compareTo(b.product.averagePrice);
    });

    return _selectDiverseScoredProducts(
      scoredProducts: scoredProducts,
      limit: 3,
    );
  }

  int _foundationConcealerRelationScore({
    required MakeupProduct foundation,
    required MakeupProduct concealer,
  }) {
    final foundationShade = _normalize(foundation.shade);

    final concealerShade = _normalize(concealer.shade);

    int score = 0;

    if (foundation.shadeFamily.isNotEmpty &&
        foundation.shadeFamily == concealer.shadeFamily) {
      score += 20;
    }

    if (foundationShade.contains('115') ||
        foundationShade.contains('ivory') ||
        foundationShade.contains('nc15')) {
      if (concealerShade.contains('light') ||
          concealerShade.contains('ivory') ||
          concealerShade.contains('fair') ||
          concealerShade.contains('10')) {
        score += 15;
      }
    }

    if (foundationShade.contains('125') ||
        foundationShade.contains('fiji') ||
        foundationShade.contains('nc20') ||
        foundationShade.contains('2n')) {
      if (concealerShade.contains('sand') ||
          concealerShade.contains('vanilla') ||
          concealerShade.contains('20') ||
          concealerShade.contains('light medium')) {
        score += 18;
      }

      if (concealerShade.contains('honey') || concealerShade.contains('deep')) {
        score -= 10;
      }
    }

    if (foundationShade.contains('220') ||
        foundationShade.contains('222') ||
        foundationShade.contains('punjab') ||
        foundationShade.contains('nc30')) {
      if (concealerShade.contains('medium') ||
          concealerShade.contains('honey') ||
          concealerShade.contains('25') ||
          concealerShade.contains('30')) {
        score += 16;
      }

      if (concealerShade.contains('fair') ||
          concealerShade.contains('porcelain')) {
        score -= 8;
      }
    }

    if (foundation.skinTones.contains('mediumDeep')) {
      if (concealerShade.contains('caramel') ||
          concealerShade.contains('deep') ||
          concealerShade.contains('35') ||
          concealerShade.contains('40')) {
        score += 16;
      }
    }

    if (foundation.skinTones.contains('deep')) {
      if (concealerShade.contains('cafe') ||
          concealerShade.contains('deep') ||
          concealerShade.contains('40') ||
          concealerShade.contains('50')) {
        score += 18;
      }
    }

    return score;
  }

  List<MakeupProduct> _findGeneralProducts({
    required String category,
    required Map<String, dynamic> result,
    required String detectedSkinTone,
    required String detectedUndertone,
    required String detectedSkinType,
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
        result['eyeColor'],
        result['hairColor'],
        result['${category}Brand'],
        result['${category}Code'],
      ].whereType<Object>().join(' '),
    );

    final scoredProducts = products.map((product) {
      final visibleMatchScore = _selectionScore(
        product: product,
        skinTone: detectedSkinTone,
        undertone: detectedUndertone,
        skinType: detectedSkinType,
      );

      int colorTagBonus = 0;

      for (final tag in product.colorTags) {
        final normalizedTag = _normalize(tag);

        if (normalizedTag.isNotEmpty && sourceText.contains(normalizedTag)) {
          colorTagBonus += 1;
        }
      }

      /*
     * Görünen uyum puanı her zaman önceliklidir.
     * Renk etiketi bonusu yalnızca aynı puanlı ürünlerde
     * sıralamayı belirleyen küçük bir yardımcı değerdir.
     */
      final rankingScore = (visibleMatchScore * 100) + colorTagBonus;

      return _ScoredProduct(product: product, score: rankingScore);
    }).toList();

    scoredProducts.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.product.averagePrice.compareTo(b.product.averagePrice);
    });

    return _selectDiverseScoredProducts(
      scoredProducts: scoredProducts,
      limit: 3,
    );
  }

  List<MakeupProduct> _selectDiverseScoredProducts({
    required List<_ScoredProduct> scoredProducts,
    required int limit,
  }) {
    final selected = <MakeupProduct>[];
    final usedBrands = <String>{};
    final usedPriceLevels = <int>{};

    for (final item in scoredProducts) {
      if (selected.length >= limit) {
        break;
      }

      final product = item.product;

      if (!usedBrands.contains(product.brand) &&
          !usedPriceLevels.contains(product.priceLevel)) {
        selected.add(product);
        usedBrands.add(product.brand);
        usedPriceLevels.add(product.priceLevel);
      }
    }

    for (final item in scoredProducts) {
      if (selected.length >= limit) {
        break;
      }

      final product = item.product;

      final alreadySelected = selected.any(
        (selectedProduct) =>
            selectedProduct.brand == product.brand &&
            selectedProduct.product == product.product &&
            selectedProduct.shade == product.shade,
      );

      if (!alreadySelected && !usedBrands.contains(product.brand)) {
        selected.add(product);
        usedBrands.add(product.brand);
      }
    }

    for (final item in scoredProducts) {
      if (selected.length >= limit) {
        break;
      }

      final product = item.product;

      final alreadySelected = selected.any(
        (selectedProduct) =>
            selectedProduct.brand == product.brand &&
            selectedProduct.product == product.product &&
            selectedProduct.shade == product.shade,
      );

      if (!alreadySelected) {
        selected.add(product);
      }
    }

    return selected.take(limit).toList();
  }

  List<MakeupProduct> _findAffordableAlternatives({
    required MakeupProduct referenceProduct,
    required String category,
    required String skinTone,
    required String undertone,
    required String skinType,
    int minPrice = 300,
    int maxPrice = 1000,
  }) {
    final alternatives = ProductCatalog.products.where((product) {
      if (product.category != category) {
        return false;
      }

      final sameProduct =
          product.brand == referenceProduct.brand &&
          product.product == referenceProduct.product &&
          product.shade == referenceProduct.shade;

      if (sameProduct) {
        return false;
      }

      if (product.shadeFamily != referenceProduct.shadeFamily) {
        return false;
      }

      final sameUndertone = product.undertones.any(
        referenceProduct.undertones.contains,
      );

      if (!sameUndertone) {
        return false;
      }

      final sameSkinTone = product.skinTones.any(
        referenceProduct.skinTones.contains,
      );

      if (!sameSkinTone) {
        return false;
      }

      return product.averagePrice >= minPrice &&
          product.averagePrice <= maxPrice;
    }).toList();

    alternatives.sort((a, b) {
      final aScore = _selectionScore(
        product: a,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final bScore = _selectionScore(
        product: b,
        skinTone: skinTone,
        undertone: undertone,
        skinType: skinType,
      );

      final scoreComparison = bScore.compareTo(aScore);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.averagePrice.compareTo(b.averagePrice);
    });

    return alternatives.take(3).toList();
  }

  String _buildShadeFamily({
    required String skinTone,
    required String undertone,
  }) {
    final undertonePart = switch (undertone) {
      'cool' => 'Cool',
      'warm' => 'Warm',
      _ => 'Neutral',
    };

    return '$skinTone$undertonePart';
  }

  String _shadeFamilyLabel(String shadeFamily) {
    const labels = {
      'lightCool': 'Açık Soğuk',
      'lightNeutral': 'Açık Nötr',
      'lightWarm': 'Açık Sıcak',
      'lightMediumCool': 'Açık-Orta Soğuk',
      'lightMediumNeutral': 'Açık-Orta Nötr',
      'lightMediumWarm': 'Açık-Orta Sıcak',
      'mediumCool': 'Orta Soğuk',
      'mediumNeutral': 'Orta Nötr',
      'mediumWarm': 'Orta Sıcak',
      'mediumDeepCool': 'Orta-Koyu Soğuk',
      'mediumDeepNeutral': 'Orta-Koyu Nötr',
      'mediumDeepWarm': 'Orta-Koyu Sıcak',
      'deepCool': 'Koyu Soğuk',
      'deepNeutral': 'Koyu Nötr',
      'deepWarm': 'Koyu Sıcak',
    };

    return labels[shadeFamily] ?? shadeFamily;
  }

  String _detectUndertone(String value) {
    final normalized = _normalize(value);

    if (normalized.contains('notr') && normalized.contains('soguk')) {
      return 'cool';
    }

    if (normalized.contains('notr') && normalized.contains('sicak')) {
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

    if (normalized.contains('cok koyu') || normalized.contains('deep')) {
      return 'deep';
    }

    if (normalized.contains('orta koyu') ||
        normalized.contains('medium deep') ||
        normalized.contains('medium-deep')) {
      return 'mediumDeep';
    }

    if (normalized.contains('acik-orta') ||
        normalized.contains('acik orta') ||
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

  const _ScoredProduct({required this.product, required this.score});
}

class _ProductMatch {
  final int score;
  final String reason;

  const _ProductMatch({required this.score, required this.reason});
}

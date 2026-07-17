enum PriceSegment {
  budget,
  midRange,
  premium,
}

class MakeupProduct {
  final String category;
  final String brand;
  final String product;
  final String shade;

  final String shadeFamily;

  final List<String> undertones;
  final List<String> skinTones;
  final List<String> colorTags;

  final PriceSegment priceSegment;
  final int priceLevel;
  final int averagePrice;

  final bool vegan;
  final bool crueltyFree;

  final String finish;
  final String coverage;
  final List<String> skinTypes;

  const MakeupProduct({
    required this.category,
    required this.brand,
    required this.product,
    required this.shade,
    this.shadeFamily = '',
    required this.undertones,
    required this.skinTones,
    required this.colorTags,

    // Eski dosyalar priceLevel kullanabilir.
    int? priceLevel,

    // Yeni dosyalar priceSegment kullanabilir.
    this.priceSegment = PriceSegment.midRange,

    this.averagePrice = 0,
    this.vegan = false,
    this.crueltyFree = false,
    this.finish = '',
    this.coverage = '',
    this.skinTypes = const [],
  }) : priceLevel = priceLevel ??
            (priceSegment == PriceSegment.budget
                ? 1
                : priceSegment == PriceSegment.premium
                    ? 3
                    : 2);

  String get priceSegmentLabel {
    if (priceLevel == 1) {
      return 'Ekonomik';
    }

    if (priceLevel == 3) {
      return 'Premium';
    }

    return 'Orta Segment';
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'brand': brand,
      'product': product,
      'shade': shade,
      'shadeFamily': shadeFamily,
      'undertones': undertones,
      'skinTones': skinTones,
      'colorTags': colorTags,
      'priceLevel': priceLevel,
      'priceSegment': priceSegmentLabel,
      'averagePrice': averagePrice,
      'vegan': vegan,
      'crueltyFree': crueltyFree,
      'finish': finish,
      'coverage': coverage,
      'skinTypes': skinTypes,
    };
  }
}
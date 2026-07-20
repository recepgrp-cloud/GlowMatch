enum PriceSegment {
  budget,
  midRange,
  premium,
}

enum ProductStore {
  trendyol,
  gratis,
  watsons,
  sephora,
  boyner,
  amazon,
  official,
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
  final int averagePrice;

  final String finish;
  final String coverage;
  final List<String> skinTypes;

  final bool vegan;
  final bool crueltyFree;

  /// Ürünün gerçekten satıldığı mağazalar.
  ///
  /// Liste boşsa uygulama yalnızca Google'da Ara seçeneğini gösterir.
  final List<ProductStore> stores;

  /// İleride doğrudan ürün veya satış ortaklığı bağlantıları
  /// ekleyebilmek için kullanılacak alanlar.
  final Map<ProductStore, String> storeLinks;

  const MakeupProduct({
    required this.category,
    required this.brand,
    required this.product,
    required this.shade,
    this.shadeFamily = '',
    this.undertones = const [],
    this.skinTones = const [],
    this.colorTags = const [],
    this.priceSegment = PriceSegment.midRange,
    this.averagePrice = 0,
    this.finish = '',
    this.coverage = '',
    this.skinTypes = const [],
    this.vegan = false,
    this.crueltyFree = false,
    this.stores = const [],
    this.storeLinks = const {},
  });

  int get priceLevel {
    switch (priceSegment) {
      case PriceSegment.budget:
        return 1;

      case PriceSegment.midRange:
        return 2;

      case PriceSegment.premium:
        return 3;
    }
  }

  String get priceSegmentLabel {
    switch (priceSegment) {
      case PriceSegment.budget:
        return 'Ekonomik';

      case PriceSegment.midRange:
        return 'Orta Segment';

      case PriceSegment.premium:
        return 'Premium';
    }
  }
}
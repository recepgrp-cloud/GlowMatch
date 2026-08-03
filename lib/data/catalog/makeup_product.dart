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
  rossmann,
  eve,
  boyner,
  amazon,
  official,
}

extension ProductStoreName on ProductStore {
  String get name => switch (this) {
        ProductStore.trendyol => 'trendyol',
        ProductStore.gratis => 'gratis',
        ProductStore.watsons => 'watsons',
        ProductStore.sephora => 'sephora',
        ProductStore.rossmann => 'rossmann',
        ProductStore.eve => 'eve',
        ProductStore.boyner => 'boyner',
        ProductStore.amazon => 'amazon',
        ProductStore.official => 'official',
      };
}

class MakeupProduct {
  final String category;
  final String brand;
  final String product;
  final String shade;

  // Eski allık, ruj ve kapatıcı kayıtlarında bu alan bulunmayabilir.
  // Bu yüzden required değildir.
  final String shadeFamily;

  final List<String> undertones;
  final List<String> skinTones;
  final List<String> colorTags;

  final PriceSegment priceSegment;
  final int averagePrice;
  final bool vegan;
  final bool crueltyFree;
  final String finish;
  final String coverage;
  final List<String> skinTypes;

  final List<ProductStore> stores;
  final Map<ProductStore, String> storeLinks;

  // Verified Catalog v2
  final bool verified;
  final String verifiedAt;
  final String sku;
  final String barcode;
  final bool isActive;

  // Eski katalog kayıtlarının priceLevel: kullanabilmesi için tutulur.
  final int? _legacyPriceLevel;

  const MakeupProduct({
    required this.category,
    required this.brand,
    required this.product,
    required this.shade,

    // Geriye uyumluluk düzeltmesi
    this.shadeFamily = '',

    required this.undertones,
    required this.skinTones,
    required this.colorTags,

    this.priceSegment = PriceSegment.midRange,
    int? priceLevel,
    this.averagePrice = 0,
    this.vegan = false,
    this.crueltyFree = false,
    this.finish = '',
    this.coverage = '',
    this.skinTypes = const [],

    this.stores = const [],
    this.storeLinks = const {},

    this.verified = false,
    this.verifiedAt = '',
    this.sku = '',
    this.barcode = '',
    this.isActive = true,
  }) : _legacyPriceLevel = priceLevel;

  int get priceLevel {
    final legacy = _legacyPriceLevel;

    if (legacy != null) {
      return legacy;
    }

    return switch (priceSegment) {
      PriceSegment.budget => 1,
      PriceSegment.midRange => 2,
      PriceSegment.premium => 3,
    };
  }

  String get priceSegmentLabel => switch (priceSegment) {
        PriceSegment.budget => 'Ekonomik',
        PriceSegment.midRange => 'Orta Segment',
        PriceSegment.premium => 'Premium',
      };

  bool get hasVerifiedStoreLink {
    if (!verified || !isActive) {
      return false;
    }

    return storeLinks.values.any((link) => link.trim().isNotEmpty);
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
      'stores': stores.map((store) => store.name).toList(),
      'storeLinks': storeLinks.map(
        (store, link) => MapEntry(store.name, link),
      ),
      'verified': verified,
      'verifiedAt': verifiedAt,
      'sku': sku,
      'barcode': barcode,
      'isActive': isActive,
    };
  }
}

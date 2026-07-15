class MakeupProduct {
  final String category;

  final String brand;
  final String product;
  final String shade;

  final List<String> undertones;
  final List<String> skinTones;
  final List<String> colorTags;

  // Yeni alanlar

  final int priceLevel; //1=Ekonomik 2=Orta 3=Premium

  final double averagePrice;

  final bool vegan;

  final bool crueltyFree;

  final String finish;

  const MakeupProduct({
    required this.category,
    required this.brand,
    required this.product,
    required this.shade,

    required this.undertones,
    required this.skinTones,
    required this.colorTags,

    this.priceLevel = 2,
    this.averagePrice = 0,
    this.vegan = false,
    this.crueltyFree = false,
    this.finish = '',
  });
}
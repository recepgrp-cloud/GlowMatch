import 'catalog/blushes.dart';
import 'catalog/concealers.dart';
import 'catalog/foundations.dart';
import 'catalog/lipsticks.dart';
import 'catalog/makeup_product.dart';

class ProductCatalog {
  const ProductCatalog._();

  // Mevcut ürünlerin hiçbiri çıkarılmaz.
  // Dört ayrı katalog dosyasındaki bütün kayıtlar tek listede birleştirilir.
  static final List<MakeupProduct> products = _buildProducts();

  static List<MakeupProduct> _buildProducts() {
    final merged = <MakeupProduct>[
      ...foundations,
      ...concealerProducts,
      ...blushProducts,
      ...lipstickProducts,

      // ============================================================
      // MAYBELLINE FIT ME - DOĞRULANMIŞ EK TONLAR
      // Mevcut foundations.dart içindeki tonlar korunur.
      // Aşağıdaki tonlar ayrıca eklenir.
      // ============================================================

      const MakeupProduct(
        category: 'foundation',
        brand: 'Maybelline',
        product: 'Fit Me Matte + Poreless',
        shade: '100 Warm Ivory',
        shadeFamily: 'lightWarm',
        undertones: ['warm'],
        skinTones: ['light'],
        colorTags: ['açık', 'sıcak', 'fildişi'],
        priceSegment: PriceSegment.midRange,
        averagePrice: 1249,
        finish: 'Doğal mat',
        coverage: 'Orta',
        skinTypes: ['normal', 'karma', 'yağlı'],
        stores: [
          ProductStore.gratis,
          ProductStore.watsons,
          ProductStore.trendyol,
        ],
        storeLinks: {
          ProductStore.gratis:
              'https://www.gratis.com/fondoten/maybelline-new-york-fit-me-matte-poreless-fondoten-100-warm-ivory-p-10256105',
          ProductStore.watsons:
              'https://www.watsons.com.tr/maybelline-new-york-fit-me-fondoten-mat-no-100/p/BP_1274112',
          ProductStore.trendyol:
              'https://www.trendyol.com/sr?q=Maybelline%20Fit%20Me%20100%20Warm%20Ivory',
        },
        verified: true,
        verifiedAt: '2026-08-01',
        sku: 'Gratis:10256105 | Watsons:1274112',
        barcode: '3600531369330',
      ),

      const MakeupProduct(
        category: 'foundation',
        brand: 'Maybelline',
        product: 'Fit Me Matte + Poreless',
        shade: '105 Natural Ivory',
        shadeFamily: 'lightNeutral',
        undertones: ['neutral'],
        skinTones: ['light'],
        colorTags: ['açık', 'nötr', 'fildişi'],
        priceSegment: PriceSegment.midRange,
        averagePrice: 1249,
        finish: 'Doğal mat',
        coverage: 'Orta',
        skinTypes: ['normal', 'karma', 'yağlı'],
        stores: [
          ProductStore.gratis,
          ProductStore.watsons,
          ProductStore.trendyol,
        ],
        storeLinks: {
          ProductStore.gratis:
              'https://www.gratis.com/fondoten/maybelline-new-york-fit-me-matte-poreless-fondoten-105-natural-ivory-p-10167353',
          ProductStore.watsons:
              'https://www.watsons.com.tr/maybelline-new-york-fit-me-mat-poreless-fondoten-no-105-natural-ivory/p/BP_165841',
          ProductStore.trendyol:
              'https://www.trendyol.com/sr?q=Maybelline%20Fit%20Me%20105%20Natural%20Ivory',
        },
        verified: true,
        verifiedAt: '2026-08-01',
        sku: 'Gratis:10167353 | Watsons:165841',
        barcode: '3600531324483',
      ),

      const MakeupProduct(
        category: 'foundation',
        brand: 'Maybelline',
        product: 'Fit Me Matte + Poreless',
        shade: '110 Porcelain',
        shadeFamily: 'lightCool',
        undertones: ['cool', 'neutral'],
        skinTones: ['light'],
        colorTags: ['açık', 'porselen', 'soğuk', 'nötr'],
        priceSegment: PriceSegment.midRange,
        averagePrice: 1249,
        finish: 'Doğal mat',
        coverage: 'Orta',
        skinTypes: ['normal', 'karma', 'yağlı'],
        stores: [
          ProductStore.gratis,
          ProductStore.watsons,
          ProductStore.trendyol,
        ],
        storeLinks: {
          ProductStore.gratis:
              'https://www.gratis.com/fondoten/maybelline-new-york-fit-me-matte-poreless-fondoten-110-porcelain-p-10033340',
          ProductStore.watsons:
              'https://www.watsons.com.tr/maybelline-new-york-fit-me-mat-poreless-fondoten-110-porcelain/p/BP_151540',
          ProductStore.trendyol:
              'https://www.trendyol.com/sr?q=Maybelline%20Fit%20Me%20110%20Porcelain',
        },
        verified: true,
        verifiedAt: '2026-08-01',
        sku: 'Gratis:10033340 | Watsons:151540',
        barcode: '3600531324506',
      ),
    ];

    // Aynı marka + ürün + ton yanlışlıkla iki kez bulunursa
    // ilk kayıt korunur. Hiçbir farklı ürün veya farklı ton silinmez.
    final unique = <String, MakeupProduct>{};

    for (final product in merged) {
      if (!product.isActive) {
        continue;
      }

      final key = [
        product.category.trim().toLowerCase(),
        product.brand.trim().toLowerCase(),
        product.product.trim().toLowerCase(),
        product.shade.trim().toLowerCase(),
      ].join('|');

      unique.putIfAbsent(key, () => product);
    }

    return List<MakeupProduct>.unmodifiable(unique.values);
  }

  static List<MakeupProduct> get verifiedProducts => products
      .where(
        (product) =>
            product.verified &&
            product.isActive &&
            product.storeLinks.isNotEmpty,
      )
      .toList(growable: false);

  static List<MakeupProduct> byCategory(String category) {
    final normalized = category.trim().toLowerCase();

    return products
        .where(
          (product) => product.category.trim().toLowerCase() == normalized,
        )
        .toList(growable: false);
  }
}

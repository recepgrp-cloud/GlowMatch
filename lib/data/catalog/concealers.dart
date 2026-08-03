import 'makeup_product.dart';

final List<MakeupProduct> concealerProducts = [
  // ============================================================
  // MAYBELLINE - FIT ME CONCEALER
  // Gratis + Watsons doğrudan ton linkleri
  // Trendyol genel aramasını ProductMatcher otomatik ekler.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '05 Ivory',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['çok açık', 'ivory', 'nötr', 'fildişi'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1049,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-fit-me-kapatici-05-ivory-p-10060060',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-fit-me-kapatici-05-ivory/p/BP_159119',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '159119',
    barcode: '0000030155831',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '10 Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral', 'cool'],
    skinTones: ['light'],
    colorTags: ['açık', 'light', 'nötr', 'pembe'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1049,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-fit-me-kapatici-10-light-p-10060056',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-fit-me-kapatici-no-10-light/p/BP_159116',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '159116',
    barcode: '0000030096585',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '15 Fair',
    shadeFamily: 'lightCool',
    undertones: ['cool'],
    skinTones: ['fair', 'light'],
    colorTags: ['çok açık', 'fair', 'soğuk', 'pembe'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1049,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-fit-me-kapatici-15-fair-p-10060057',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-fit-me-kapatici-15-fair/p/BP_159117',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '159117',
    barcode: '0000030096592',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '20 Sand',
    shadeFamily: 'lightWarm',
    undertones: ['warm', 'neutral'],
    skinTones: ['lightMedium'],
    colorTags: ['açık buğday', 'kum', 'sand', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1049,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-fit-me-kapatici-20-sand-p-10060058',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-fit-me-kapatici-20-sand/p/BP_159118',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '159118',
    barcode: '0000030096608',
    isActive: true,
  ),

  // Bu tonlar mevcut katalogda kalıyor.
  // Doğrudan Gratis/Watsons sayfası doğrulandığında linkleri eklenecek.
  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '25 Medium',
    undertones: ['neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['buğday', 'orta', 'medium', 'nötr'],
  ),
  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '30 Honey',
    undertones: ['warm'],
    skinTones: ['medium'],
    colorTags: ['bal', 'honey', 'sıcak', 'altın'],
  ),
  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '35 Deep',
    undertones: ['warm', 'neutral'],
    skinTones: ['mediumDeep'],
    colorTags: ['orta koyu', 'deep', 'sıcak'],
  ),
  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '40 Caramel',
    undertones: ['warm'],
    skinTones: ['mediumDeep', 'deep'],
    colorTags: ['karamel', 'caramel', 'koyu', 'sıcak'],
  ),
  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Fit Me Concealer',
    shade: '50 Cafe',
    undertones: ['neutral', 'warm'],
    skinTones: ['deep'],
    colorTags: ['çok koyu', 'kahve', 'cafe'],
  ),

  
  // ============================================================
  // L'ORÉAL PARIS - WATSONS TÜRKİYE GÜNCEL KAPATICILAR
  // Watsons kategori sayfasında listelenen 11 doğrudan ton kaydı.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '322 Ivory',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['fair', 'light'],
    colorTags: ['ivory', 'açık', 'sarı', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-322-ivory-p-10208214',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-322/p/BP_165809',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '165809',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '323 Fawn',
    shadeFamily: 'lightMediumNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['fawn', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-323-fawn-p-10208211',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-323-fawn/p/BP_165810',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '165810',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '326 Vanilla',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['vanilla', 'açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-326-vanilla-p-10208212',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-326-vanilla/p/BP_165811',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '165811',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '327 Cashmere',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['cashmere', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-327-cashmere-p-10208213',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-327-cashmere/p/BP_165812',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '165812',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '328 Lin',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['lin', 'keten', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-328-lin-p-10208064',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-328-lin/p/BP_1316077',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1316077',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'Infaillible 24H Concealer',
    shade: '330 Pecan',
    shadeFamily: 'mediumDeepWarm',
    undertones: ['warm'],
    skinTones: ['medium', 'mediumDeep'],
    colorTags: ['pecan', 'kahve', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-infaillible-24h-tum-yuze-uygulanabilir-kapatici-330-pecan-p-10208210',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-infaillible-24h-kapatici-330-pecan/p/BP_165813',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '165813',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '1N Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['1N', 'light', 'nötr', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Doğal aydınlık',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-1n-p-10208068',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-true-match-aydinlatan-serum-kapatici-1n-light/p/BP_1397550',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1397550',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '1.5N',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['1.5N', 'nötr', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Doğal aydınlık',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-1-5n-p-10208067',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-true-match-aydinlatan-serum-kapatici-15n/p/BP_1397543',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1397543',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '1R',
    shadeFamily: 'lightCool',
    undertones: ['cool'],
    skinTones: ['fair', 'light'],
    colorTags: ['1R', 'pembe', 'soğuk', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Doğal aydınlık',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-1r-p-10208065',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-true-match-aydinlatan-serum-kapatici-1r/p/BP_1397557',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1397557',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '2R',
    shadeFamily: 'lightMediumCool',
    undertones: ['cool'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['2R', 'pembe', 'soğuk', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Doğal aydınlık',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-2r-p-10208066',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-true-match-aydinlatan-serum-kapatici-2r/p/BP_1397564',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1397564',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '3R',
    shadeFamily: 'mediumCool',
    undertones: ['cool'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['3R', 'pembe', 'soğuk', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1799,
    finish: 'Doğal aydınlık',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-3r-p-10208302',
      ProductStore.watsons:
          'https://www.watsons.com.tr/loreal-paris-true-match-aydinlatan-serum-kapatici-3r/p/BP_1397571',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1397571',
    isActive: true,
  ),


  // ============================================================
  // L'ORÉAL PARIS - GRATIS'E ÖZEL EK TRUE MATCH TONLARI
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '4N',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['medium', 'mediumDeep'],
    colorTags: ['4N', 'nötr', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1849,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-4n-p-10208301',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '10208301',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: "L'Oréal Paris",
    product: 'True Match Radiant Serum Concealer',
    shade: '4D Light Medium',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['4D', 'light medium', 'altın', 'sıcak', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1849,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/loreal-paris-true-match-aydinlatan-serum-kapatici-4d-light-medium-p-10208300',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '10208300',
    isActive: true,
  ),


  // ============================================================
  // NYX PROFESSIONAL MAKEUP - WATSONS GÜNCEL KAPATICILAR
  // 16 benzersiz ürün/ton kaydı.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Concealer Serum',
    shade: '01 Fair',
    shadeFamily: 'fairNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['fair', 'çok açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-kapatici-serum-01-fair/p/BP_1319556',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1319556',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Concealer Serum',
    shade: '02 Light',
    shadeFamily: 'lightCool',
    undertones: ['cool'],
    skinTones: ['fair', 'light'],
    colorTags: ['light', 'açık', 'soğuk'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-kapatici-serum-02-light/p/BP_1319563',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1319563',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Concealer Serum',
    shade: '03 Vanilla',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['vanilla', 'sarı', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-kapatici-serum-03-vanilla/p/BP_1319570',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1319570',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Concealer Serum',
    shade: '04 Beige',
    shadeFamily: 'lightMediumNeutral',
    undertones: ['neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['beige', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-kapatici-serum-04-beige/p/BP_1319577',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1319577',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Concealer Serum',
    shade: '05 Golden',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['medium', 'mediumDeep'],
    colorTags: ['golden', 'altın', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-kapatici-serum-05-golden/p/BP_1319584',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1319584',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '04 Alabaster',
    shadeFamily: 'fairNeutral',
    undertones: ['neutral'],
    skinTones: ['fair'],
    colorTags: ['alabaster', 'çok açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-04-alabaster/p/BP_1430072',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430072',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '06 Fair',
    shadeFamily: 'fairWarm',
    undertones: ['warm'],
    skinTones: ['fair', 'light'],
    colorTags: ['fair', 'açık', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-06-fair/p/BP_1430079',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430079',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '07 Light Ivory',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light'],
    colorTags: ['light ivory', 'açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-07-light-ivory/p/BP_1430058',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430058',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '08 Vanilla',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['vanilla', 'sarı', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-08-vanilla/p/BP_1430044',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430044',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '10 Light Beige',
    shadeFamily: 'lightMediumNeutral',
    undertones: ['neutral'],
    skinTones: ['lightMedium'],
    colorTags: ['light beige', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-10-light-beige/p/BP_1430065',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430065',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '11 Neutral Beige',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['neutral beige', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-11-neutral-beige/p/BP_1430093',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430093',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '12 Natural',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['medium'],
    colorTags: ['natural', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-12-natural/p/BP_1430051',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430051',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '14 Medium Olive',
    shadeFamily: 'mediumOlive',
    undertones: ['olive'],
    skinTones: ['medium', 'mediumDeep'],
    colorTags: ['medium olive', 'zeytin', 'olive'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-14-medium-olive/p/BP_1430086',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430086',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Wonder Snatch Hydrating Concealer',
    shade: '15 Neutral Tan',
    shadeFamily: 'mediumDeepNeutral',
    undertones: ['neutral'],
    skinTones: ['mediumDeep', 'deep'],
    colorTags: ['neutral tan', 'bronz', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-wonder-snatch-nemlendirme-etkili-kapatici-15-neutral-tan/p/BP_1430100',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1430100',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: 'Bare With Me Conceal and Calm Serum',
    shade: '15',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['medium', 'mediumDeep'],
    colorTags: ['15', 'nötr', 'serum'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1499,
    finish: 'Nemli doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-bare-with-me-conceal-and-calm-serum-no-15/p/BP_1367275',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1367275',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'NYX Professional Makeup',
    product: '3C Color Correcting Palette',
    shade: '6 Color Correctors',
    shadeFamily: 'corrector',
    undertones: ['neutral'],
    skinTones: ['fair', 'light', 'lightMedium', 'medium', 'mediumDeep', 'deep'],
    colorTags: ['yeşil', 'lavanta', 'sarı', 'şeftali', 'somon', 'renk eşitleyici'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1399,
    finish: 'Doğal',
    coverage: 'Düzeltici',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/nyx-professional-makeup-3c-renk-esitleyici-palet/p/BP_155538',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '155538',
    isActive: true,
  ),


  // ============================================================
  // FLORMAR - WATSONS GÜNCEL KAPATICILAR
  // 11 benzersiz ürün/ton kaydı.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '001 Fair',
    shadeFamily: 'fairNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['fair', 'çok açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-001-fair-p-10200073',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-yogun-pigmentli-likit-kapatici-001-fair/p/BP_1391327',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1391327',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '002 Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['light', 'açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-002-light-p-10200075',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-yogun-pigmentli-likit-kapatici-002-light/p/BP_1391334',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1391334',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '003 Soft Beige',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['soft beige', 'bej', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-003-soft-beige-p-10201066',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-concealer-kremsi-likit-kapatici-no-03-soft-beige/p/BP_1398236',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1398236',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '006 Medium Beige',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['medium beige', 'bej', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-006-medium-beige-p-10200076',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-yogun-pigmentli-likit-kapatici-006-medium-beige/p/BP_1391348',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1391348',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '007 Light Beige',
    shadeFamily: 'lightMediumNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['light beige', 'bej', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-007-light-beige-p-10203726',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-kapatici-no-07-light-beige/p/BP_1409506',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1409506',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '011 Matcha Veil',
    shadeFamily: 'correctorGreen',
    undertones: ['olive'],
    skinTones: ['fair', 'light', 'lightMedium', 'medium', 'mediumDeep'],
    colorTags: ['matcha', 'yeşil', 'kızarıklık karşıtı'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Düzeltici',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-011-matcha-veil-p-10216509',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-kapatici-no-011-matcha-veil/p/BP_1487087',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1487087',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Stay Perfect Concealer',
    shade: '012 Salmon Cover',
    shadeFamily: 'correctorSalmon',
    undertones: ['warm'],
    skinTones: ['fair', 'light', 'lightMedium', 'medium'],
    colorTags: ['salmon', 'somon', 'göz altı düzeltici'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1179,
    finish: 'Doğal',
    coverage: 'Düzeltici',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-stay-perfect-yogun-pigmentli-kapatici-012-salmon-cover-p-10216510',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-stay-perfect-kapatici-no-012-salmon-cover/p/BP_1487094',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1487094',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Perfect Coverage Concealer',
    shade: '2 Ivory',
    shadeFamily: 'fairWarm',
    undertones: ['warm'],
    skinTones: ['fair', 'light'],
    colorTags: ['ivory', 'açık', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1099,
    finish: 'Yarı mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-perfect-coverage-mavi-isik-korumali-yari-mat-kapatici-002-ivory-p-10216514',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-perfect-coverage-kapatici-no-2-ivory/p/BP_1481942',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1481942',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Perfect Coverage Concealer',
    shade: '5 Soft Beige',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['soft beige', 'bej', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1099,
    finish: 'Yarı mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici-concealer/flormar-perfect-coverage-mavi-isik-korumali-yari-mat-kapatici-005-soft-beige-p-10216513',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-perfect-coverage-kapatici-no-5-soft-beige/p/BP_1481935',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1481935',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Perfect Coverage Concealer',
    shade: '20 Fair Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['fair light', 'açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1099,
    finish: 'Yarı mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-perfect-coverage-mavi-isik-korumali-yari-mat-kapatici-020-fair-light-p-10216511',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-perfect-coverage-kapatici-no-20-fair-light/p/BP_1481921',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1481921',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Flormar',
    product: 'Perfect Coverage Concealer',
    shade: '30 Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['light', 'açık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1099,
    finish: 'Yarı mat',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/flormar-perfect-coverage-mavi-isik-korumali-yari-mat-kapatici-030-light-p-10216512',
      ProductStore.watsons:
          'https://www.watsons.com.tr/flormar-perfect-coverage-kapatici-no-30-light/p/BP_1481928',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1481928',
    isActive: true,
  ),


  // ============================================================
  // GOLDEN ROSE - WATSONS + GRATIS GÜNCEL KAPATICILAR
  // 6 benzersiz ürün/ton kaydı.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Just Touch Liquid Concealer',
    shade: '01',
    shadeFamily: 'fairNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['01', 'çok açık', 'nötr', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 625,
    finish: 'Doğal aydınlık',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/golden-rose-just-touch-liquid-concealer-no-1-p-10081253',
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-just-touch-likit-kapatici-no-01/p/BP_1342390',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1342390',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Just Touch Liquid Concealer',
    shade: '03',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['03', 'açık', 'nötr', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 625,
    finish: 'Doğal aydınlık',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/golden-rose-just-touch-liquid-concealer-no-3-p-10081254',
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-just-touch-likit-kapatici-no-03/p/BP_1342397',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1342397',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Just Touch Liquid Concealer',
    shade: '05',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['05', 'orta bej', 'sıcak', 'aydınlık'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 625,
    finish: 'Doğal aydınlık',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/golden-rose-just-touch-liquid-concealer-no-5-p-10081255',
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-just-touch-likit-kapatici-no-05/p/BP_1342411',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1342411',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Stick Concealer',
    shade: '01',
    shadeFamily: 'fairNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['01', 'çok açık', 'nötr', 'stick'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 420,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-stick-kapatici-no-01/p/BP_126676',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '126676',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Stick Concealer',
    shade: '02',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['02', 'açık bej', 'sıcak', 'stick'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 420,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/golden-rose-stick-concealer-kapatici-no-02-p-11000117',
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-stick-kapatici-no-02/p/BP_126677',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '126677',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Golden Rose',
    product: 'Stick Concealer',
    shade: '04',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['04', 'orta bej', 'sıcak', 'stick'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 420,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/golden-rose-stick-concealer-kapatici-no-04-p-11000119',
      ProductStore.watsons:
          'https://www.watsons.com.tr/golden-rose-stick-kapatici-no-04/p/BP_126679',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '126679',
    isActive: true,
  ),

  // ============================================================
  // MAYBELLINE - INSTANT ANTI AGE ERASER (TÜRKİYE TONLARI)
  // Watsons'taki mevcut 9 ürün/ton doğrulandı.
  // Gratis'te doğrudan doğrulanan tonlara ikinci link eklendi.
  // Trendyol genel aramasını ProductMatcher otomatik ekler.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '00 Ivory',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['çok açık', 'ivory', 'fildişi', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-00-ivory-p-10081189',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-eraser-anti-age-kapatici-no-00-ivory/p/BP_161989',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '161989',
    barcode: '3600531465230',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '01 Light',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['light'],
    colorTags: ['açık', 'light', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-01-light-p-10033327',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-kapatici-01-light/p/BP_151534',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '151534',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '02 Nude',
    shadeFamily: 'lightWarm',
    undertones: ['warm', 'neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['açık', 'nude', 'bej', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-02-nude-p-10033328',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-kapatici-no-02-nude/p/BP_151535',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '151535',
    barcode: '3600530733859',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '03 Fair',
    shadeFamily: 'lightCool',
    undertones: ['cool', 'neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['çok açık', 'fair', 'pembe', 'soğuk'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-03-fair-p-10038657',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-kapatici-no-03-fair/p/BP_154331',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '154331',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '05 Brighten',
    shadeFamily: 'lightCool',
    undertones: ['cool'],
    skinTones: ['fair', 'light'],
    colorTags: ['aydınlatıcı', 'pembe', 'brighten', 'soğuk'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-05-brighten-p-10199072',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-kapatici-05-brighten/p/BP_1386371',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1386371',
    barcode: '3600531396831',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '06 Neutralizer',
    shadeFamily: 'lightWarm',
    undertones: ['warm'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['sarı', 'neutralizer', 'renk eşitleyici', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-06-neutralizer-p-10038658',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-kapatici-no-06-neutralizer/p/BP_154333',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '154333',
    barcode: '3600531396855',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '07 Sand',
    shadeFamily: 'lightWarm',
    undertones: ['warm', 'neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['kum', 'sand', 'buğday', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-07-sand-p-10081190',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-eraser-kapatici-07-sand/p/BP_161990',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '161990',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: '121 Light Honey',
    shadeFamily: 'mediumWarm',
    undertones: ['warm'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['bal', 'honey', 'altın', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Yüksek',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-instant-anti-age-eraser-kapatici-121-light-honey-p-10256083',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-eraser-eye-light-honey/p/BP_1232819',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1232819',
    barcode: '3600531561291',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Instant Anti Age Eraser',
    shade: 'Green Corrector',
    shadeFamily: 'correctorGreen',
    undertones: ['neutral'],
    skinTones: ['fair', 'light', 'lightMedium', 'medium', 'mediumDeep', 'deep'],
    colorTags: ['yeşil', 'kızarıklık', 'renk düzenleyici', 'corrector'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1749,
    finish: 'Doğal',
    coverage: 'Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'yağlı'],
    stores: [ProductStore.watsons],
    storeLinks: {
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-instant-anti-age-colour-correct-green/p/BP_1425137',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1425137',
    barcode: '3600531698614',
    isActive: true,
  ),

  // ============================================================
  // MAYBELLINE - LIFTER CONCEALER (TÜRKİYE TONLARI)
  // 6 tonun tamamında Gratis + Watsons doğrudan ürün linki vardır.
  // Trendyol genel aramasını ProductMatcher otomatik ekler.
  // ============================================================

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '05',
    shadeFamily: 'lightNeutral',
    undertones: ['neutral'],
    skinTones: ['fair', 'light'],
    colorTags: ['çok açık', 'aydınlık', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-05-p-10215482',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-05/p/BP_1480395',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480395',
    barcode: '3600531712587',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '15',
    shadeFamily: 'lightCool',
    undertones: ['cool', 'neutral'],
    skinTones: ['light'],
    colorTags: ['açık', 'pembe', 'soğuk'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-15-p-10215483',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-15/p/BP_1480374',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480374',
    barcode: '3600531712594',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '20',
    shadeFamily: 'lightWarm',
    undertones: ['warm', 'neutral'],
    skinTones: ['light', 'lightMedium'],
    colorTags: ['açık buğday', 'bej', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-20-p-10215484',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-20/p/BP_1480381',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480381',
    barcode: '3600531712600',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '25',
    shadeFamily: 'mediumNeutral',
    undertones: ['neutral'],
    skinTones: ['lightMedium', 'medium'],
    colorTags: ['buğday', 'orta', 'nötr'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-25-p-10215485',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-25/p/BP_1480388',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480388',
    barcode: '3600531712617',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '30',
    shadeFamily: 'mediumWarm',
    undertones: ['warm', 'neutral'],
    skinTones: ['medium'],
    colorTags: ['orta', 'altın', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-30-p-10215486',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-30/p/BP_1480360',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480360',
    barcode: '3600531712624',
    isActive: true,
  ),

  MakeupProduct(
    category: 'concealer',
    brand: 'Maybelline New York',
    product: 'Lifter Concealer',
    shade: '35',
    shadeFamily: 'mediumDeepWarm',
    undertones: ['warm'],
    skinTones: ['mediumDeep'],
    colorTags: ['orta koyu', 'karamel', 'sıcak'],
    priceSegment: PriceSegment.midRange,
    averagePrice: 1299,
    finish: 'Doğal aydınlık',
    coverage: 'Hafif-Orta',
    skinTypes: ['normal', 'kuru', 'karma', 'hassas'],
    stores: [ProductStore.gratis, ProductStore.watsons],
    storeLinks: {
      ProductStore.gratis:
          'https://www.gratis.com/kapatici/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-35-p-10215487',
      ProductStore.watsons:
          'https://www.watsons.com.tr/maybelline-new-york-lifter-kafein-ve-peptitler-iceren-nemlendiren-ve-aydinlatan-kapatici-35/p/BP_1480367',
    },
    verified: true,
    verifiedAt: '2026-08-03',
    sku: '1480367',
    barcode: '3600531712631',
    isActive: true,
  ),

  // ============================================================
  // L'ORÉAL PARIS - INFALLIBLE FULL WEAR CONCEALER
  // ============================================================















];
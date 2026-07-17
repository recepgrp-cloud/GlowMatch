import 'catalog/blushes.dart' as blush_data;
import 'catalog/concealers.dart' as concealer_data;
import 'catalog/foundations.dart' as foundation_data;
import 'catalog/lipsticks.dart' as lipstick_data;
import 'catalog/makeup_product.dart';

export 'catalog/makeup_product.dart';

class ProductCatalog {
  static final List<MakeupProduct> products = [
    ...foundation_data.foundations,
    ...concealer_data.concealerProducts,
    ...blush_data.blushProducts,
    ...lipstick_data.lipstickProducts,
  ];
}
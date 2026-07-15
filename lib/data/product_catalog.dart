import 'catalog/blushes.dart';
import 'catalog/concealers.dart';
import 'catalog/foundations.dart';
import 'catalog/lipsticks.dart';
import 'catalog/makeup_product.dart';

export 'catalog/makeup_product.dart';

class ProductCatalog {
  static const List<MakeupProduct> products = [
    ...foundationProducts,
    ...concealerProducts,
    ...blushProducts,
    ...lipstickProducts,
  ];
}
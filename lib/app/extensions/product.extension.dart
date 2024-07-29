import 'package:tajiri_sdk/tajiri_sdk.dart';

extension ExtensionMainCategoryId on Product {
  String get mainCategoryId => category.mainCategoryId;
  bool get isBundle => type == "BUNDLE";
  bool get hasVariants => variants.isNotEmpty;
}

import 'package:tajiri_pos_mobile/domain/entities/stock_inventory.entity.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

extension InventoryExtension on Inventory {
  StockInventoryEntity toStockInventory(qty) => StockInventoryEntity(
      idFoodInventory: id,
      quantity: qty,
      oldquantity: quantity,
      nameFoodInventory: name,
      categoryFoodIdInventory: categoryId);
}

class StockInventoryEntity {
  int quantity;
  int oldquantity;
  String? idFoodInventory;
  String? nameFoodInventory;
  String? categoryFoodIdInventory;

  StockInventoryEntity({
    required this.quantity,
    required this.oldquantity,
    required this.idFoodInventory,
    required this.nameFoodInventory,
    required this.categoryFoodIdInventory,
  });
}

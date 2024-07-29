class ProductFoodVariant {
  ProductFoodVariant({
    String? id,
    int? quantity,
    int? price,
    String? name,
    String? foodVariantCategoryId,
    bool? managementStock,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _quantity = quantity;
    _price = price;
    _name = name;
    _foodVariantCategoryId = foodVariantCategoryId;
    _managementStock = managementStock;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  ProductFoodVariant.fromJson(dynamic json) {
    _id = json['id'];
    _quantity = json['quantity'];
    _price = json['price'];
    _name = json['name'];
    _foodVariantCategoryId = json['foodVariantCategoryId'];
    _managementStock = json['managementStock'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  int? _quantity;
  int? _price;
  String? _name;
  String? _foodVariantCategoryId;
  bool? _managementStock;
  String? _createdAt;
  String? _updatedAt;

  ProductFoodVariant copyWith({
    String? id,
    int? quantity,
    int? price,
    String? name,
    String? foodVariantCategoryId,
    bool? managementStock,
    String? createdAt,
    String? updatedAt,
  }) =>
      ProductFoodVariant(
        id: id ?? _id,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
        name: name ?? _name,
        foodVariantCategoryId: foodVariantCategoryId ?? _foodVariantCategoryId,
        managementStock: managementStock ?? _managementStock,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  String? get id => _id;
  int? get quantity => _quantity;
  int? get price => _price;
  String? get name => _name;
  String? get foodVariantCategoryId => _foodVariantCategoryId;
  bool? get managementStock => _managementStock;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['name'] = _name;
    map['foodVariantCategoryId'] = _foodVariantCategoryId;
    map['managementStock'] = _managementStock;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

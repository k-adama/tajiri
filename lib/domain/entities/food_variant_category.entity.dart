class FoodVariantCategoryEntity {
  FoodVariantCategoryEntity({
    String? id,
    String? name,
    String? foodId,
    String? createdAt,
    String? updatedAt,
    List<FoodVariant>? foodVariant,
  }) {
    _id = id;
    _name = name;
    _foodId = foodId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _foodVariant = foodVariant;
  }
  FoodVariantCategoryEntity.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _foodId = json['foodId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['foodVariant'] != null) {
      _foodVariant = [];
      json['foodVariant'].forEach((v) {
        _foodVariant?.add(FoodVariant.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  String? _foodId;
  String? _createdAt;
  String? _updatedAt;
  List<FoodVariant>? _foodVariant;

  FoodVariantCategoryEntity copyWith({
    String? id,
    String? name,
    String? foodId,
    String? createdAt,
    String? updatedAt,
    List<FoodVariant>? foodVariant,
  }) =>
      FoodVariantCategoryEntity(
        id: id ?? _id,
        name: name ?? _name,
        foodId: foodId ?? _foodId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        foodVariant: foodVariant ?? _foodVariant,
      );

  String? get id => _id;
  String? get name => _name;
  String? get foodId => _foodId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<FoodVariant>? get foodVariant => _foodVariant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['foodId'] = _foodId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['foodVariant'] = _foodVariant;
    if (_foodVariant != null) {
      map['foodVariant'] = _foodVariant?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FoodVariant {
  FoodVariant({
    String? id,
    int? quantity,
    int? price,
    String? name,
    String? FoodVariantCategoryEntityId,
    bool? managementStock,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _quantity = quantity;
    _price = price;
    _name = name;
    _FoodVariantCategoryEntityId = FoodVariantCategoryEntityId;
    _managementStock = managementStock;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  FoodVariant.fromJson(dynamic json) {
    _id = json['id'];
    _quantity = json['quantity'];
    _price = json['price'];
    _name = json['name'];
    _FoodVariantCategoryEntityId = json['FoodVariantCategoryEntityId'];
    _managementStock = json['managementStock'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  int? _quantity;
  int? _price;
  String? _name;
  String? _FoodVariantCategoryEntityId;
  bool? _managementStock;
  String? _createdAt;
  String? _updatedAt;

  FoodVariant copyWith({
    String? id,
    int? quantity,
    int? price,
    String? name,
    String? FoodVariantCategoryEntityId,
    bool? managementStock,
    String? createdAt,
    String? updatedAt,
  }) =>
      FoodVariant(
        id: id ?? _id,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
        name: name ?? _name,
        FoodVariantCategoryEntityId:
            FoodVariantCategoryEntityId ?? _FoodVariantCategoryEntityId,
        managementStock: managementStock ?? _managementStock,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  String? get id => _id;
  int? get quantity => _quantity;
  int? get price => _price;
  String? get name => _name;
  String? get FoodVariantCategoryEntityId => _FoodVariantCategoryEntityId;
  bool? get managementStock => _managementStock;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['name'] = _name;
    map['FoodVariantCategoryEntityId'] = _FoodVariantCategoryEntityId;
    map['managementStock'] = _managementStock;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

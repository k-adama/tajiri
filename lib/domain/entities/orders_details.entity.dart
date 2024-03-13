import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';

class OrderDetailsEntity {
  OrderDetailsEntity({
    String? id,
    String? foodId,
    String? bundleId,
    int? price,
    int? quantity,
    String? orderId,
    String? createdAt,
    String? updatedAt,
    FoodDataEntity? food,
    dynamic bundle,
  }) {
    _id = id;
    _foodId = foodId;
    _bundleId = bundleId;
    _price = price;
    _quantity = quantity;
    _orderId = orderId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _food = food;
    _bundle = bundle;
  }

  OrderDetailsEntity.fromJson(dynamic json) {
    _id = json['id'];
    _foodId = json['foodId'];
    _bundleId = json['bundleId'];
    _price = json['price'];
    _quantity = json['quantity'];
    _orderId = json['orderId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _food = json['food'] != null ? FoodDataEntity.fromJson(json['food']) : null;
    _bundle = json['bundle'];
  }

  String? _id;
  String? _foodId;
  String? _bundleId;
  int? _price;
  int? _quantity;
  String? _orderId;
  String? _createdAt;
  String? _updatedAt;
  FoodDataEntity? _food;
  dynamic? _bundle;

  String? get id => _id;
  String? get foodId => _foodId;
  String? get bundleId => _bundleId;
  int? get price => _price;
  int? get quantity => _quantity;
  String? get orderId => _orderId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  FoodDataEntity? get food => _food;
  dynamic get bundle => _bundle;

  OrderDetailsEntity copyWith({
    String? id,
    String? foodId,
    String? bundleId,
    int? price,
    int? quantity,
    String? orderId,
    String? createdAt,
    String? updatedAt,
    FoodDataEntity? food,
    dynamic? bundle,
  }) =>
      OrderDetailsEntity(
        id: id ?? _id,
        foodId: foodId ?? _foodId,
        bundleId: bundleId ?? _bundleId,
        price: price ?? _price,
        quantity: quantity ?? _quantity,
        orderId: orderId ?? _orderId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        food: food ?? _food,
        bundle: bundle ?? _bundle,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['foodId'] = _foodId;
    map['bundleId'] = _bundleId;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['orderId'] = _orderId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_food != null) {
      map['food'] = _food?.toJson();
    }
    if (_bundle != null) {
      map['bundle'] = _bundle?.toJson();
    }
    return map;
  }
}

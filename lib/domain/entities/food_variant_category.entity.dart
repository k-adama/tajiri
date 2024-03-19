import 'package:tajiri_pos_mobile/domain/entities/food_variant.entity.dart';

class FoodVariantCategoryEntity {
  FoodVariantCategoryEntity({
    String? id,
    String? name,
    String? foodId,
    String? createdAt,
    String? updatedAt,
    List<FoodVariantEntity>? foodVariant,
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
        _foodVariant?.add(FoodVariantEntity.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  String? _foodId;
  String? _createdAt;
  String? _updatedAt;
  List<FoodVariantEntity>? _foodVariant;

  FoodVariantCategoryEntity copyWith({
    String? id,
    String? name,
    String? foodId,
    String? createdAt,
    String? updatedAt,
    List<FoodVariantEntity>? foodVariant,
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
  List<FoodVariantEntity>? get foodVariant => _foodVariant;

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

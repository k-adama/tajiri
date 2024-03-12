import 'package:tajiri_pos_mobile/domain/entities/categorie_entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_variant_category.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/stock_data.entity.dart';

class FoodDataEntity {
  FoodDataEntity({
    String? id,
    int? price,
    String? description,
    String? categoryId,
    String? name,
    bool? isAvailable,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    int? quantity,
    String? type,
    List<StockDataEnty>? Stock,
    CategoryEntity? category,
    List<FoodVariantCategoryEntity>? foodVariantCategory,
  }) {
    _id = id;
    _categoryId = categoryId;
    _isAvailable = isAvailable;
    _price = price;
    _description = description;
    _name = name;
    _quantity = quantity;
    _imageUrl = imageUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _category = category;
    _type = type;
    _Stock = Stock;
    _foodVariantCategory = foodVariantCategory;
  }

  FoodDataEntity.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['categoryId'];
    _price = json['price'];
    _description = json['description'];
    _isAvailable = json['isAvailable'];
    _name = json['name'];
    _quantity = json['quantity'];
    _imageUrl = json['imageUrl'];
    _type = json['type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _category = json['category'] != null
        ? CategoryEntity.fromJson(json['category'])
        : null;

    if (json['Stock'] != null) {
      _Stock = [];
      json['Stock'].forEach((v) {
        _Stock?.add(StockDataEnty.fromJson(v));
      });
    }

    if (json['foodVariantCategory'] != null) {
      _foodVariantCategory = [];
      json['foodVariantCategory'].forEach((v) {
        _foodVariantCategory?.add(FoodVariantCategoryEntity.fromJson(v));
      });
    }
  }

  String? _id;
  String? _categoryId;
  String? _description;
  bool? _isAvailable;
  int? _price;
  String? _name;
  String? _imageUrl;
  String? _createdAt;
  String? _updatedAt;
  String? _type;
  int? _quantity;
  List<StockDataEnty>? _Stock;
  CategoryEntity? _category;
  List<FoodVariantCategoryEntity>? _foodVariantCategory;

  FoodDataEntity copyWith({
    String? id,
    String? categoryId,
    String? description,
    bool? isAvailable,
    int? price,
    String? name,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    int? quantity,
    String? type,
    List<StockDataEnty>? Stock,
    CategoryEntity? category,
    List<FoodVariantCategoryEntity>? foodVariantCategory,
  }) =>
      FoodDataEntity(
        id: id ?? _id,
        categoryId: categoryId ?? _categoryId,
        isAvailable: isAvailable ?? _isAvailable,
        description: description ?? _description,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
        name: name ?? _name,
        imageUrl: imageUrl ?? _imageUrl,
        Stock: Stock ?? _Stock,
        type: type ?? _type,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        category: category ?? _category,
        foodVariantCategory: foodVariantCategory ?? _foodVariantCategory,
      );

  String? get id => _id;

  String? get categoryId => _categoryId;

  String? get description => _description;

  String? get name => _name;
  bool? get isAvailable => _isAvailable;

  String? get imageUrl => _imageUrl;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;
  String? get type => _type;

  int? get price => _price;

  int? get quantity => _quantity;
  List<StockDataEnty>? get Stock => _Stock;

  CategoryEntity? get category => _category;
  List<FoodVariantCategoryEntity>? get foodVariantCategory =>
      _foodVariantCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['categoryId'] = _categoryId;
    map['description'] = _description;
    map['isAvailable'] = _isAvailable;
    map['name'] = _name;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['imageUrl'] = _imageUrl;
    map['type'] = _type;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_Stock != null) {
      map['Stock'] = _Stock?.map((v) => v.toJson()).toList();
    }
    if (_category != null) {
      map['category'] = _category?.toJson();
    }

    if (_foodVariantCategory != null) {
      map['foodVariantCategory'] =
          _foodVariantCategory?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

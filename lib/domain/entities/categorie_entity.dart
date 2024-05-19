class CategoryEntity {
  CategoryEntity({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _restaurantId = restaurantId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  CategoryEntity.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _restaurantId = json['restaurantId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  String? _description;
  String? _imageUrl;
  String? _restaurantId;
  String? _createdAt;
  String? _updatedAt;

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) =>
      CategoryEntity(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        imageUrl: imageUrl ?? _imageUrl,
        restaurantId: restaurantId ?? _restaurantId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  String? get restaurantId => _restaurantId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['restaurantId'] = _restaurantId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

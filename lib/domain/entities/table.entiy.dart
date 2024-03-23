class TableEntity {
  TableEntity({
    String? id,
    String? name,
    String? description,
    int? persons,
    String? imageUrl,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
    bool? status,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _persons = persons;
    _restaurantId = restaurantId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
  }

  TableEntity.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _persons = json['persons'];
    _restaurantId = json['restaurantId'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  String? _description;
  String? _imageUrl;
  int? _persons;
  String? _restaurantId;
  String? _createdAt;
  String? _updatedAt;
  bool? _status;

  TableEntity copyWith(
          {String? id,
          String? name,
          String? description,
          String? imageUrl,
          int? persons,
          String? restaurantId,
          String? createdAt,
          String? updatedAt,
          bool? status}) =>
      TableEntity(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        imageUrl: imageUrl ?? _imageUrl,
        persons: persons ?? _persons,
        restaurantId: restaurantId ?? _restaurantId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        status: status ?? _status,
      );

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  String? get restaurantId => _restaurantId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get persons => _persons;
  bool? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['persons'] = _persons;
    map['status'] = _status;
    map['restaurantId'] = _restaurantId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    return map;
  }
}

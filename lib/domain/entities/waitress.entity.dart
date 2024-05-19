class WaitressEntity {
  WaitressEntity({
    String? id,
    String? name,
    String? restaurantId,
    String? gender,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _restaurantId = restaurantId;
    _gender = gender;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  WaitressEntity.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _restaurantId = json['restaurantId'];
    _gender = json['gender'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  String? _restaurantId;
  String? _gender;
  String? _createdAt;
  String? _updatedAt;

  WaitressEntity copyWith(
          {String? id,
          String? name,
          String? restaurantId,
          String? gender,
          String? createdAt,
          String? updatedAt}) =>
      WaitressEntity(
        id: id ?? _id,
        name: name ?? _name,
        restaurantId: restaurantId ?? _restaurantId,
        gender: gender ?? _gender,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;
  String? get name => _name;
  String? get restaurantId => _restaurantId;
  String? get gender => _gender;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['restaurantId'] = _restaurantId;
    map['gender'] = _gender;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    return map;
  }
}

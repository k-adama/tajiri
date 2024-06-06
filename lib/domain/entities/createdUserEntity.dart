class CreatedUserEntity {
  CreatedUserEntity({
    String? id,
    String? lastname,
    String? firstname,
    String? phone,
  }) {
    _id = id;
    _lastname = lastname;
    _firstname = firstname;
    _phone = phone;
  }

  CreatedUserEntity.fromJson(dynamic json) {
    _id = json['id'];
    _lastname = json['lastname'];
    _firstname = json['firstname'];
    _phone = json['phone'];
  }

  String? _id;
  String? _lastname;
  String? _firstname;
  String? _phone;

  CreatedUserEntity copyWith({
    String? id,
    String? lastname,
    String? firstname,
    String? phone,
  }) =>
      CreatedUserEntity(
        id: id ?? _id,
        lastname: lastname ?? _lastname,
        firstname: firstname ?? _firstname,
        phone: phone ?? _phone,
      );

  String? get id => _id;
  String? get lastname => _lastname;
  String? get firstname => _firstname;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['lastname'] = _lastname;
    map['firstname'] = _firstname;
    map['phone'] = _phone;

    return map;
  }
}

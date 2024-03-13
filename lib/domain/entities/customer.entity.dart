class CustomerEntity {
  CustomerEntity({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? birthDate,
    String? city,
    String? state,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _email = email;
    _firstname = firstname;
    _lastname = lastname;
    _phone = phone;
    _birthDate = birthDate;
    _city = city;
    _state = state;
    _restaurantId = restaurantId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  String? _id;
  String? _email;
  String? _firstname;
  String? _lastname;
  String? _phone;
  String? _birthDate;
  String? _city;
  String? _state;
  String? _restaurantId;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  String? get email => _email;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get phone => _phone;
  String? get birthDate => _birthDate;
  String? get city => _city;
  String? get state => _state;
  String? get restaurantId => _restaurantId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  CustomerEntity.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _phone = json['phone'];
    _birthDate = json['birthDate'];
    _city = json['city'];
    _state = json['state'];
    _restaurantId = json['restaurantId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  CustomerEntity copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? birthDate,
    String? city,
    String? state,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) =>
      CustomerEntity(
        id: id ?? _id,
        email: email ?? _email,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
        phone: phone ?? _phone,
        birthDate: birthDate ?? _birthDate,
        city: city ?? _city,
        state: state ?? _state,
        restaurantId: restaurantId ?? _restaurantId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['phone'] = _phone;
    map['birthDate'] = _birthDate;
    map['city'] = _city;
    map['state'] = _state;
    map['restaurantId'] = _restaurantId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

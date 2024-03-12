class StockDataEnty {
  StockDataEnty({
    String? id,
    String? foodId,
    String? userId,
    String? type,
    int? oldQuantity,
    int? addQuantity,
    String? imageUrl,
    String? createdAt,
    StockUserData? user,
  }) {
    _id = id;
    _foodId = foodId;
    _userId = userId;
    _type = type;
    _oldQuantity = oldQuantity;
    _addQuantity = addQuantity;
    _imageUrl = imageUrl;
    _createdAt = createdAt;
    _user = user;
  }

  StockDataEnty.fromJson(dynamic json) {
    _id = json['id'];
    _foodId = json['foodId'];
    _userId = json['userId'];
    _type = json['type'];
    _imageUrl = json['imageUrl'];
    _oldQuantity = json['oldQuantity'];
    _addQuantity = json['addQuantity'];
    _createdAt = json['createdAt'];
    _user = json['user'] != null ? StockUserData.fromJson(json['user']) : null;
  }

  String? _id;
  String? _foodId;
  String? _userId;
  String? _type;
  int? _oldQuantity;
  int? _addQuantity;
  String? _imageUrl;
  String? _createdAt;
  StockUserData? _user;

  StockDataEnty copyWith({
    String? id,
    String? foodId,
    String? userId,
    String? type,
    int? oldQuantity,
    int? addQuantity,
    String? imageUrl,
    String? createdAt,
    StockUserData? user,
  }) =>
      StockDataEnty(
        id: id ?? _id,
        foodId: foodId ?? _foodId,
        userId: userId ?? _userId,
        type: type ?? _type,
        oldQuantity: oldQuantity ?? _oldQuantity,
        addQuantity: addQuantity ?? _addQuantity,
        imageUrl: imageUrl ?? _imageUrl,
        createdAt: createdAt ?? _createdAt,
        user: user ?? _user,
      );

  String? get id => _id;

  String? get foodId => _foodId;

  String? get userId => _userId;

  String? get type => _type;

  String? get imageUrl => _imageUrl;

  String? get createdAt => _createdAt;

  int? get oldQuantity => _oldQuantity;

  int? get addQuantity => _addQuantity;
  StockUserData? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['foodId'] = _foodId;
    map['userId'] = _userId;
    map['type'] = _type;
    map['imageUrl'] = _imageUrl;
    map['addQuantity'] = _addQuantity;
    map['oldQuantity'] = _oldQuantity;
    map['imageUrl'] = _imageUrl;
    map['createdAt'] = _createdAt;

    if (_user != null) {
      map['user'] = _user?.toJson();
    }

    return map;
  }
}

class StockUserData {
  StockUserData({
    String? id,
    String? email,
    bool? enabled,
    String? password,
    String? firstname,
    String? lastname,
    String? gender,
    String? phone,
    String? birthDate,
    String? city,
    String? country,
    String? roleId,
    bool? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _email = email;
    _enabled = enabled;
    _password = password;
    _firstname = firstname;
    _lastname = lastname;
    _gender = gender;
    _phone = phone;
    _birthDate = birthDate;
    _city = city;
    _country = country;
    _roleId = roleId;
    _status = status;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
  }

  StockUserData.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _enabled = json['enabled'] != null ? json['enabled'] : false;
    _password = json['password'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _gender = json['gender'];
    _phone = json['phone'];
    _birthDate = json['birthDate'];
    _city = json['city'];
    _country = json['country'];
    _roleId = json['roleId'];
    _status = json['status'] != null ? json['status'] : false;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _createdAt;
  String? _email;
  bool? _enabled;
  String? _password;
  String? _firstname;
  String? _lastname;
  String? _gender;
  String? _phone;
  String? _birthDate;
  String? _city;
  String? _country;
  String? _roleId;
  bool? _status;
  String? _updatedAt;

  StockUserData copyWith({
    String? id,
    String? email,
    bool? enabled,
    String? password,
    String? firstname,
    String? lastname,
    String? gender,
    String? phone,
    String? birthDate,
    String? city,
    String? country,
    String? roleId,
    bool? status,
    String? createdAt,
    String? updatedAt,
  }) =>
      StockUserData(
        id: id ?? _id,
        email: email ?? _email,
        enabled: enabled ?? _enabled,
        password: password ?? _password,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
        gender: gender ?? _gender,
        phone: phone ?? _phone,
        birthDate: birthDate ?? _birthDate,
        city: city ?? _city,
        country: country ?? _country,
        roleId: roleId ?? _roleId,
        status: status ?? _status,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
      );

  String? get id => _id;

  String? get email => _email;

  bool? get enabled => _enabled;

  bool? get status => _status;

  String? get password => _password;

  String? get phone => _phone;

  String? get birthDate => _birthDate;

  String? get city => _city;

  String? get country => _country;

  String? get roleId => _roleId;

  String? get firstname => _firstname;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get lastname => _lastname;

  String? get gender => _gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['enabled'] = _enabled;
    map['password'] = _password;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['gender'] = _gender;
    map['phone'] = _phone;
    map['birthDate'] = _birthDate;
    map['city'] = _city;
    map['country'] = _country;
    map['roleId'] = _roleId;
    map['status'] = _status;
    map['updatedAt'] = _updatedAt;
    map['createdAt'] = _createdAt;
    return map;
  }
}

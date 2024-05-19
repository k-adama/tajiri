import 'package:tajiri_pos_mobile/domain/entities/restaurant_user.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/role.entity.dart';

class UserEntity {
  String? id;
  String? firstname;
  String? lastname;
  String? referral;
  String? email;
  String? phone;
  String? birthDate;
  String? gender;
  String? emailVerifiedAt;
  String? registeredAt;
  String? active;
  String? img;
  String? referalCode;
  bool? canUpdateOrCanceled; // permission for update or cancel
  RoleEntity? role;
  List<RestaurantUser>? restaurantUser;

  UserEntity(
      {this.id,
      this.firstname,
      this.lastname,
      this.referral,
      this.email,
      this.phone,
      this.birthDate,
      this.gender,
      this.emailVerifiedAt,
      this.registeredAt,
      this.active,
      this.img,
      this.referalCode,
      this.canUpdateOrCanceled,
      this.role,
      this.restaurantUser});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    referral = json['referral'];
    email = json['email'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    gender = json['gender'];
    emailVerifiedAt = json['email_verified_at'];
    registeredAt = json['registered_at'];
    active = json['active'];
    img = json['img'];
    referalCode = json['referalCode'];
    canUpdateOrCanceled = json['canUpdateOrCanceled'];
    role = json['role'] != null ? RoleEntity.fromJson(json['role']) : null;
    if (json['restaurantUser'] != null) {
      restaurantUser = <RestaurantUser>[];
      json['restaurantUser'].forEach((v) {
        restaurantUser!.add(RestaurantUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['referral'] = referral;
    data['email'] = email;
    data['phone'] = phone;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    data['email_verified_at'] = emailVerifiedAt;
    data['registered_at'] = registeredAt;
    data['active'] = active;
    data['img'] = img;
    data['canUpdateOrCanceled'] = canUpdateOrCanceled;
    data['referalCode'] = referalCode;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    if (restaurantUser != null) {
      data['restaurantUser'] = restaurantUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

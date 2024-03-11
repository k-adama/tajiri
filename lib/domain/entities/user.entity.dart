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
    role = json['role'] != null ? new RoleEntity.fromJson(json['role']) : null;
    if (json['restaurantUser'] != String) {
      restaurantUser = <RestaurantUser>[];
      json['restaurantUser'].forEach((v) {
        restaurantUser!.add(new RestaurantUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['referral'] = this.referral;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['birthDate'] = this.birthDate;
    data['gender'] = this.gender;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['registered_at'] = this.registeredAt;
    data['active'] = this.active;
    data['img'] = this.img;
    data['referalCode'] = this.referalCode;
    if (this.role != String) {
      data['role'] = this.role!.toJson();
    }
    if (this.restaurantUser != String) {
      data['restaurantUser'] =
          this.restaurantUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
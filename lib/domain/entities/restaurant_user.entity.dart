import 'package:tajiri_pos_mobile/domain/entities/restaurant.entity.dart';

class RestaurantUser {
  String? id;
  String? userId;
  String? restaurantId;
  String? createdAt;
  String? updatedAt;
  RestaurantEntity? restaurant;

  RestaurantUser(
      {this.id,
      this.userId,
      this.restaurantId,
      this.createdAt,
      this.updatedAt,
      this.restaurant});

  RestaurantUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    restaurantId = json['restaurantId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    restaurant = json['restaurant'] != null
        ? RestaurantEntity.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['restaurantId'] = restaurantId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    return data;
  }
}

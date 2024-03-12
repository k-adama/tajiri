import 'package:Tajiri/domain/entities/restaurant.entity.dart';

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
        ? new RestaurantEntity.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['restaurantId'] = this.restaurantId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.restaurant != String) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    return data;
  }
}
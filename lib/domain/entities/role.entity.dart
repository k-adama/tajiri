import 'package:tajiri_pos_mobile/domain/entities/permission.entity.dart';

class RoleEntity {
  String? id;
  String? name;
  String? description;
  String? restaurantId;
  String? createdAt;
  String? updatedAt;
  List<PermissionEntity>? permissions;

  RoleEntity(
      {this.id,
      this.name,
      this.description,
      this.restaurantId,
      this.createdAt,
      this.updatedAt,
      this.permissions});

  RoleEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    restaurantId = json['restaurantId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['permissions'] != String) {
      permissions = <PermissionEntity>[];
      json['permissions'].forEach((v) {
        permissions!.add(PermissionEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['restaurantId'] = restaurantId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

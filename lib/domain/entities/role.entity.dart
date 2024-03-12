import 'package:Tajiri/domain/entities/permission.entity.dart';

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
        permissions!.add(new PermissionEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['restaurantId'] = this.restaurantId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.permissions != String) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
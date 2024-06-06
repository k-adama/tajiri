class PermissionEntity {
  String? id;
  String? roleId;
  bool? dashboardGlobal;
  bool? dashboardUnique;
  bool? inventory;
  bool? managementProducts;
  bool? managementCustomers;
  bool? settingsRestaurant;
  bool? canUpdateOrCanceled;
  String? createdAt;
  String? updatedAt;

  PermissionEntity(
      {this.id,
      this.roleId,
      this.dashboardGlobal,
      this.dashboardUnique,
      this.inventory,
      this.managementProducts,
      this.managementCustomers,
      this.settingsRestaurant,
      this.canUpdateOrCanceled,
      this.createdAt,
      this.updatedAt});

  PermissionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    dashboardGlobal = json['dashboardGlobal'];
    dashboardUnique = json['dashboardUnique'];
    inventory = json['inventory'];
    managementProducts = json['managementProducts'];
    managementCustomers = json['managementCustomers'];
    settingsRestaurant = json['settingsRestaurant'];
    canUpdateOrCanceled = json['canUpdateOrCanceled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roleId'] = roleId;
    data['dashboardGlobal'] = dashboardGlobal;
    data['dashboardUnique'] = dashboardUnique;
    data['inventory'] = inventory;
    data['managementProducts'] = managementProducts;
    data['managementCustomers'] = managementCustomers;
    data['settingsRestaurant'] = settingsRestaurant;
    data['canUpdateOrCanceled'] = canUpdateOrCanceled;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

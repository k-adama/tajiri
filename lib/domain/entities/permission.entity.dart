class PermissionEntity {
  String? id;
  String? roleId;
  bool? dashboardGlobal;
  bool? dashboardUnique;
  bool? inventory;
  bool? managementProducts;
  bool? managementCustomers;
  bool? settingsRestaurant;
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['dashboardGlobal'] = this.dashboardGlobal;
    data['dashboardUnique'] = this.dashboardUnique;
    data['inventory'] = this.inventory;
    data['managementProducts'] = this.managementProducts;
    data['managementCustomers'] = this.managementCustomers;
    data['settingsRestaurant'] = this.settingsRestaurant;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
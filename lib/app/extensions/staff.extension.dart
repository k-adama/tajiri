// ignore_for_file: constant_identifier_names

import 'package:tajiri_sdk/tajiri_sdk.dart';

enum Role {
  OWNER(value: 'OWNER'),
  MANAGER(value: 'MANAGER'),
  WAITRESS(value: 'WAITRESS'),
  CASHIER(value: 'CASHIER'),
  COOK(value: 'COOK'),
  BARMAN(value: 'BARMAN'),
  STOCK_MANAGER(value: 'STOCK_MANAGER'),
  UNKNOWN(value: 'UNKNOWN');

  final String value;

  const Role({required this.value});

  factory Role.fromString(String role) {
    return Role.values.firstWhere(
      (el) => el.value == role,
      orElse: () => Role.UNKNOWN,
    );
  }
}

extension StaffExtension on Staff? {
  bool get isOwner {
    if (this == null) {
      return false; // ou true selon ton besoin
    }
    return getRole == Role.OWNER;
  }

  bool hasPermission(String permissionName) {
    if (this == null) {
      return false;
    }
    return this!
        .permissions
        .any((permission) => permission.name == permissionName);
  }

  Role get getRole => Role.fromString(this?.role ?? "UNKNOWN");

  String? get idOwnerForGetOrder {
    switch (getRole) {
      case Role.CASHIER || Role.OWNER || Role.MANAGER:
        return null; // pour afficher toutes les commandes
      default:
        return this?.id;
    }
  }
}

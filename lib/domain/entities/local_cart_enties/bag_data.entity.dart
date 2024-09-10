import 'package:tajiri_sdk/tajiri_sdk.dart';

class BagDataEntity {
  int index;
  String? idOrderToUpdate;
  String? orderNumber;
  List<DepositCartItem> bagProducts;
  List<DepositCartItem>? deleteProducts;

  String? waitressId;
  String? tableId;
  String? settleOrderId;

  BagDataEntity({
    required this.index,
    required this.bagProducts,
    this.idOrderToUpdate,
    this.orderNumber,
    this.waitressId,
    this.tableId,
    this.settleOrderId = "ON_PLACE",
    List<DepositCartItem>? deleteProducts,
  }) : deleteProducts = deleteProducts ?? [];

  factory BagDataEntity.fromJson(Map<String, dynamic> json) {
    return BagDataEntity(
      index: json['index'],
      waitressId: json['waitressId'],
      tableId: json['tableId'],
      settleOrderId: json['settleOrderId'],
      idOrderToUpdate: json['idOrderToUpdate'],
      orderNumber: json['orderNumber'],
      bagProducts: (json['bagProducts'] as List<dynamic>)
          .map((itemJson) => DepositCartItem.fromJson(itemJson))
          .toList(),
      deleteProducts: (json['deleteProducts'] as List<dynamic>)
          .map((itemJson) => DepositCartItem.fromJson(itemJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'index': index,
      'waitressId': waitressId,
      'tableId': tableId,
      'settleOrderId': settleOrderId,
      'idOrderToUpdate': idOrderToUpdate,
      'orderNumber': orderNumber,
      'bagProducts': bagProducts.map((item) => item.toJson()).toList(),
      'deleteProducts': deleteProducts?.map((item) => item.toJson()).toList(),
    };
    return data;
  }

  BagDataEntity copyWith() {
    return BagDataEntity(
      index: index,
      waitressId: waitressId,
      tableId: tableId,
      idOrderToUpdate: idOrderToUpdate,
      settleOrderId: settleOrderId,
      orderNumber: orderNumber,
      bagProducts: List<DepositCartItem>.from(
          bagProducts.map((item) => item.copyWith())),
      deleteProducts: List<DepositCartItem>.from(
          deleteProducts!.map((item) => item.copyWith())),
    );
  }
}

class DepositCartItem {
  String? id;
  String? name;
  int? price;
  int? quantity;
  bool? isConsigned;

  int? totalAmount;
  Product? depositProduct;
  String? itemId;

  DepositCartItem({
    this.id,
    this.quantity,
    this.name,
    this.price,
    this.totalAmount,
    this.depositProduct,
    this.itemId,
  });

  factory DepositCartItem.fromJson(Map<String, dynamic> json) {
    return DepositCartItem(
      id: json['id'],
      quantity: json['quantity'],
      itemId: json['itemId'],
      name: json['name'],
      price: json['price'],
      totalAmount: json['totalAmount'],
      depositProduct: Product.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'quantity': quantity,
      'name': name,
      'price': price,
      'itemId': itemId,
      'totalAmount': totalAmount,
      'foodDataEntity': depositProduct?.toJson(),
    };
    return data;
  }

  DepositCartItem copyWith() {
    return DepositCartItem(
      id: id,
      quantity: quantity,
      name: name,
      price: price,
      totalAmount: totalAmount,
      depositProduct: depositProduct,
    );
  }
}

import 'package:tajiri_sdk/tajiri_sdk.dart';

class PrinterModelEntity {
  String? userName;
  String? restoName;
  String? userPhone;

  DateTime? createdOrder;
  String? statusOrder;
  String? orderNumber;
  String? orderCustomerId;

  String? orderPaymentMethodId;
  String? orderWaitressId;
  String? orderTableId;

  int grandTotal;

  List<OrderPrinterProduct> orderPrinterProducts;

  PrinterModelEntity({
    required this.userName,
    required this.restoName,
    required this.userPhone,
    required this.createdOrder,
    required this.statusOrder,
    required this.orderNumber,
    required this.orderCustomerId,
    required this.orderPaymentMethodId,
    required this.orderWaitressId,
    required this.orderTableId,
    required this.orderPrinterProducts,
    required this.grandTotal,
  });
}

class OrderPrinterProduct {
  int quantity;
  String? orderProductId;
  String? productId; // id du produit
  String? variantId;
  String? productVariantName;
  String productName;
  String typeOfCooking;
  int productPrice;

  OrderPrinterProduct({
    required this.quantity,
    required this.productName,
    required this.orderProductId,
    required this.productId,
    required this.variantId,
    this.productVariantName,
    required this.productPrice,
    required this.typeOfCooking,
  });

  int get totalPrice => quantity * productPrice;

  OrderPrinterProduct copyWith({
    int? quantity,
    String? orderProductId, // id de l'item orderProduct
    String? productId, // id du produit
    String? productName,
    String? variantId,
    String? productVariantName,
    String? typeOfCooking,
    int? productPrice,
  }) {
    return OrderPrinterProduct(
      quantity: quantity ?? this.quantity,
      orderProductId: orderProductId ?? this.orderProductId,
      productId: productId ?? this.productId, // id du produit
      productName: productName ?? this.productName,
      typeOfCooking: typeOfCooking ?? this.typeOfCooking,
      productPrice: productPrice ?? this.productPrice,
      variantId: variantId ?? this.variantId,
      productVariantName: productVariantName ?? this.productVariantName,
    );
  }
}

extension OrderToPrinterModelEntity on Order {
  PrinterModelEntity toPrinterModelEntity(
      String? userName, String? restoName, String? userPhone) {
    return PrinterModelEntity(
      userName: userName ?? "",
      restoName: restoName ?? "",
      userPhone: userPhone ?? "",
      createdOrder: createdAt,
      statusOrder: status,
      orderNumber: orderNumber.toString(),
      orderCustomerId: customerId,
      orderPaymentMethodId:
          payments.isEmpty ? null : payments[0].paymentMethodId,
      orderWaitressId: waitressId,
      orderTableId: tableId,
      grandTotal: grandTotal,
      orderPrinterProducts: orderProducts.map((orderProduct) {
        return orderProduct.toOrderPrinterProduct();
      }).toList(),
    );
  }
}

extension ToOrderPrinterProduct on OrderProduct {
  OrderPrinterProduct toOrderPrinterProduct() {
    final typeOfCooking =
        (productTypeOfCooking != null) ? '(${productTypeOfCooking?.name})' : '';
    return OrderPrinterProduct(
      quantity: quantity,
      productName: product.name,
      productPrice: price,
      typeOfCooking: typeOfCooking,
      productId: productId, // id du produit
      orderProductId: id, // id de l'item orderProduct);
      variantId: variantId,
      productVariantName: variant?.name,
    );
  }
}

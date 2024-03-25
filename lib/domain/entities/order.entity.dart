import 'package:tajiri_pos_mobile/domain/entities/customer.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_details.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/payment_method.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/table.entiy.dart';
import 'package:tajiri_pos_mobile/domain/entities/waitress.entity.dart';

class OrderEntity {
  OrderEntity({
    String? id,
    int? orderNumber,
    int? subTotal,
    int? grandTotal,
    String? paymentMethodId,
    String? restaurantId,
    String? tableId,
    String? waitressId,
    String? createdId,
    String? customerType,
    String? customerId,
    String? orderType,
    String? pinCode,
    String? address,
    String? couponCode,
    String? orderNotes,
    int? discountAmount,
    String? deliveryDate,
    String? status,
    String? createdAt,
    String? updatedAt,
    int? tax,
    PaymentMethodEntity? paymentMethod,
    CustomerEntity? customer,
    List<OrderDetailsEntity>? orderDetails,
    TableEntity? table,
    WaitressEntity? waitress,
  }) {
    _id = id;
    _orderNumber = orderNumber;
    _subTotal = subTotal;
    _grandTotal = grandTotal;
    _paymentMethodId = paymentMethodId;
    _restaurantId = restaurantId;
    _createdId = createdId;
    _customerType = customerType;
    _customerId = customerId;
    _orderType = orderType;
    _pinCode = pinCode;
    _address = address;
    _couponCode = couponCode;
    _orderNotes = orderNotes;
    _discountAmount = discountAmount;
    _deliveryDate = deliveryDate;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _paymentMethod = paymentMethod;
    _customer = customer;
    _orderDetails = orderDetails;
    _tableId = tableId;
    _waitressId = waitressId;
    _table = table;
    _waitress = waitress;
  }

  OrderEntity.fromJson(dynamic json) {
    _id = json['id'];
    _orderNumber = json['orderNumber'];
    _subTotal = json['subTotal'];
    _grandTotal = json['grandTotal'];
    _paymentMethodId = json['paymentMethodId'];
    _restaurantId = json['restaurantId'];
    _createdId = json['createdId'];
    _customerType = json['customerType'];
    _tableId = json['tableId'];
    _waitressId = json['waitressId'];
    _customerId = json['customerId'];
    _orderType = json['orderType'];
    _pinCode = json['pinCode'];
    _address = json['address'];
    _couponCode = json['couponCode'];
    _orderNotes = json['orderNotes'];
    _discountAmount = json['discountAmount'];
    _deliveryDate = json['deliveryDate'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _tax = json['tax'];
    _table = json['table'] != null ? TableEntity.fromJson(json['table']) : null;
    _waitress = json['waitress'] != null
        ? WaitressEntity.fromJson(json['waitress'])
        : null;
    _paymentMethod = json['paymentMethod'] != null
        ? PaymentMethodEntity.fromJson(json['paymentMethod'])
        : null;
    _customer = json['customer'] != null
        ? CustomerEntity.fromJson(json['customer'])
        : null;

    if (json['orderDetails'] != null) {
      _orderDetails = [];
      json['orderDetails'].forEach((v) {
        _orderDetails?.add(OrderDetailsEntity.fromJson(v));
      });
    }
  }

  String? _id;
  int? _orderNumber;
  int? _subTotal;
  int? _grandTotal;
  String? _paymentMethodId;
  String? _restaurantId;
  String? _createdId;
  String? _customerType;
  String? _customerId;
  String? _orderType;
  String? _pinCode;
  String? _address;
  String? _couponCode;
  String? _orderNotes;
  int? _discountAmount;
  String? _tableId;
  String? _waitressId;
  String? _deliveryDate;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _tax;
  TableEntity? _table;
  WaitressEntity? _waitress;
  PaymentMethodEntity? _paymentMethod;
  CustomerEntity? _customer;
  List<OrderDetailsEntity>? _orderDetails;

  OrderEntity copyWith({
    String? id,
    int? orderNumber,
    int? subTotal,
    int? grandTotal,
    String? paymentMethodId,
    String? restaurantId,
    String? createdId,
    String? customerType,
    String? customerId,
    String? orderType,
    String? pinCode,
    String? address,
    String? couponCode,
    String? orderNotes,
    int? discountAmount,
    String? deliveryDate,
    String? status,
    String? createdAt,
    String? updatedAt,
    int? tax,
    String? tableId,
    String? waitressId,
    PaymentMethodEntity? paymentMethod,
    CustomerEntity? customer,
    WaitressEntity? waitress,
    List<OrderDetailsEntity>? orderDetails,
  }) =>
      OrderEntity(
          id: _id ?? id,
          orderNumber: _orderNumber ?? orderNumber,
          subTotal: _subTotal ?? subTotal,
          grandTotal: _grandTotal ?? grandTotal,
          paymentMethodId: _paymentMethodId ?? paymentMethodId,
          restaurantId: _restaurantId ?? restaurantId,
          createdId: _createdId ?? createdId,
          customerType: _customerType ?? customerType,
          customerId: _customerId ?? customerId,
          orderType: _orderType ?? orderType,
          pinCode: _pinCode ?? pinCode,
          address: _address ?? address,
          couponCode: _couponCode ?? couponCode,
          orderNotes: _orderNotes ?? orderNotes,
          discountAmount: _discountAmount ?? discountAmount,
          deliveryDate: _deliveryDate ?? deliveryDate,
          status: _status ?? status,
          createdAt: _createdAt ?? createdAt,
          updatedAt: _updatedAt ?? updatedAt,
          tax: _tax ?? tax,
          paymentMethod: _paymentMethod ?? paymentMethod,
          customer: _customer ?? customer,
          tableId: _tableId ?? tableId,
          waitressId: _waitressId ?? waitressId,
          table: _table ?? table,
          waitress: _waitress ?? waitress,
          orderDetails: _orderDetails ?? orderDetails);

  String? get id => _id;
  int? get orderNumber => _orderNumber;
  int? get subTotal => _subTotal;
  int? get grandTotal => _grandTotal;
  String? get paymentMethodId => _paymentMethodId;
  String? get restaurantId => _restaurantId;
  String? get createdId => _createdId;
  String? get customerType => _customerType;
  String? get customerId => _customerId;
  String? get orderType => _orderType;
  String? get pinCode => _pinCode;
  String? get address => _address;
  String? get couponCode => _couponCode;
  String? get orderNotes => _orderNotes;
  String? get tableId => _tableId;
  String? get waitressId => _waitressId;
  TableEntity? get table => _table;
  WaitressEntity? get waitress => _waitress;
  int? get discountAmount => _discountAmount;
  int? get tax => _tax;
  String? get deliveryDate => _deliveryDate;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  PaymentMethodEntity? get paymentMethod => _paymentMethod;
  CustomerEntity? get customer => _customer;
  List<OrderDetailsEntity>? get orderDetails => _orderDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['orderNumber'] = _orderNumber;
    map['subTotal'] = _subTotal;
    map['grandTotal'] = _grandTotal;
    map['paymentMethodId'] = _paymentMethodId;
    map['restaurantId'] = _restaurantId;
    map['createdId'] = _createdId;
    map['customerType'] = _customerType;
    map['customerId'] = _customerId;
    map['orderType'] = _orderType;
    map['pinCode'] = _pinCode;
    map['address'] = _address;
    map['couponCode'] = _couponCode;
    map['tableId'] = _tableId;
    map['waitressId'] = _waitressId;
    map['orderNotes'] = _orderNotes;
    map['discountAmount'] = _discountAmount;
    map['deliveryDate'] = _deliveryDate;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['tax'] = _tax;
    if (_paymentMethod != null) {
      map['paymentMethod'] = _paymentMethod?.toJson();
    }
    if (_customer != null) {
      map['customer'] = _customer?.toJson();
    }
    if (_table != null) {
      map['table'] = _table?.toJson();
    }
    if (_waitress != null) {
      map['waitress'] = _waitress?.toJson();
    }
    if (_orderDetails != null) {
      map['orderDetails'] = _orderDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

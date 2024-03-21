class OrdersReportsEntity {
  OrdersReportsEntity({
    List<SalesDataEntity>? sales,
    int? total,
  }) {
    _sales = sales;
    _total = total;
  }

  OrdersReportsEntity.fromJson(dynamic json) {
    _total = json['total'];
    if (json['sales'] != null) {
      _sales = [];
      json['sales'].forEach((v) {
        _sales?.add(SalesDataEntity.fromJson(v));
      });
    }
  }

  OrdersReportsEntity copyWith({
    List<SalesDataEntity>? SalesDataEntity,
    int? total,
  }) =>
      OrdersReportsEntity(sales: sales ?? _sales, total: total ?? _total);

  List<SalesDataEntity>? _sales;
  int? _total;

  List<SalesDataEntity>? get sales => _sales;
  int? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    if (_sales != null) {
      map['sales'] = _sales?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SalesDataEntity {
  SalesDataEntity({
    String? id,
    String? productName,
    int? productQtyStart,
    int? productQtySupply,
    int? productPriceTotal,
    int? productQtySales,
    int? productQtyFinal,
  }) {
    _id = id;
    _productName = productName;
    _productQtyStart = productQtyStart;
    _productQtySupply = productQtySupply;
    _productPriceTotal = productPriceTotal;
    _productQtySales = productQtySales;
    _productQtyFinal = productQtyFinal;
  }

  SalesDataEntity.fromJson(dynamic json) {
    _id = json['id'];
    _productName = json['productName'];
    _productQtyStart = json['productQtyStart'];
    _productQtySupply = json['productQtySupply'];
    _productPriceTotal = json['productPriceTotal'];
    _productQtySales = json['productQtySales'];
    _productQtyFinal = json['productQtyFinal'];
  }

  String? _id;
  String? _productName;
  int? _productQtyStart;
  int? _productQtySupply;
  int? _productPriceTotal;
  int? _productQtySales;
  int? _productQtyFinal;

  SalesDataEntity copyWith({
    String? id,
    String? productName,
    int? productQtyStart,
    int? productQtySupply,
    int? productPriceTotal,
    int? productQtySales,
    int? productQtyFinal,
  }) =>
      SalesDataEntity(
        id: _id ?? id,
        productName: _productName ?? productName,
        productQtyStart: _productQtyStart ?? productQtyStart,
        productQtySupply: _productQtySupply ?? productQtySupply,
        productPriceTotal: _productPriceTotal ?? productPriceTotal,
        productQtySales: _productQtySales ?? productQtySales,
        productQtyFinal: _productQtyFinal ?? productQtyFinal,
      );

  String? get id => _id;
  String? get productName => _productName;
  int? get productQtyStart => _productQtyStart;
  int? get productQtySupply => _productQtySupply;
  int? get productPriceTotal => _productPriceTotal;
  int? get productQtySales => _productQtySales;
  int? get productQtyFinal => _productQtyFinal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productName'] = _productName;
    map['productQtyStart'] = _productQtyStart;
    map['productQtySupply'] = _productQtySupply;
    map['productPriceTotal'] = _productPriceTotal;
    map['productQtySales'] = _productQtySales;
    map['productQtyFinal'] = _productQtyFinal;
    return map;
  }
}

class PaymentMethodDataEntity {
  String name;
  int total;
  String id;

  PaymentMethodDataEntity(
      {required this.name, required this.total, required this.id});

  factory PaymentMethodDataEntity.fromJson(Map<String, dynamic> json) {
    return PaymentMethodDataEntity(
      name: json['name'] as String,
      total: json['total'] as int,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
      'id': id,
    };
  }
}

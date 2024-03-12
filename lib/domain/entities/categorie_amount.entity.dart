class CategoryAmountEntity {
  String name;
  int total;
  String icon;

  CategoryAmountEntity(
      {required this.name, required this.total, required this.icon});

  factory CategoryAmountEntity.fromJson(Map<String, dynamic> json) {
    return CategoryAmountEntity(
      name: json['name'] as String,
      total: json['total'] as int,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
      'icon': icon,
    };
  }
}

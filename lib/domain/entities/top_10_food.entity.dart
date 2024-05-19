class Top10FoodEntity {
  String name;
  int total;

  Top10FoodEntity({required this.name, required this.total});

  factory Top10FoodEntity.fromJson(Map<String, dynamic> json) {
    return Top10FoodEntity(
      name: json['name'] as String,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
    };
  }
}

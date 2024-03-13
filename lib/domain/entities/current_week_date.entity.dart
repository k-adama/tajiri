class CurentWeekDateEntity {
  DateTime startDate;
  DateTime endDate;

  CurentWeekDateEntity({required this.startDate, required this.endDate});

  factory CurentWeekDateEntity.fromJson(Map<String, dynamic> json) {
    return CurentWeekDateEntity(
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

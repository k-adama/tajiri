class TutorielEntity {
  TutorielEntity({
    this.id,
    this.minatureUrl,
    this.videoUrl,
    this.description,
    this.createdAt,
  });

  String? id;
  String? minatureUrl;
  String? videoUrl;
  String? description;
  DateTime? createdAt;

  factory TutorielEntity.fromJson(Map<String, dynamic> json) {
    return TutorielEntity(
      id: json["id"],
      minatureUrl: json["minature_url"],
      videoUrl: json["video_url"],
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"])?.toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "minature_url": minatureUrl,
        "video_url": videoUrl,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
      };
}

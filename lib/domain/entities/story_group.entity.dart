class StoryGroupEntity {
  StoryGroupEntity({this.name, this.logoImg, this.id});

  String? logoImg;
  String? name;
  String? id;

  factory StoryGroupEntity.fromJson(Map<String, dynamic> json) {
    return StoryGroupEntity(
      id: json["id"],
      logoImg: json["logoImg"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logoImg": logoImg,
        "name": name,
      };
}

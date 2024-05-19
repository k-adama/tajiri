class StoryEntity {
  StoryEntity({
    this.shopId,
    this.logoImg,
    this.title,
    this.productUuid,
    this.productTitle,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  int? shopId;
  String? logoImg;
  String? title;
  String? productUuid;
  String? productTitle;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory StoryEntity.fromJson(Map<String, dynamic> json) {
    return StoryEntity(
      shopId: json["shopId"],
      logoImg: json["logoImg"],
      title: json["title"],
      productUuid: json["productUuid"],
      productTitle: json["productTitle"],
      url: json["url"],
      createdAt: DateTime.tryParse(json["createdAt"])?.toLocal(),
      // updatedAt: DateTime.tryParse(json["updatedAt"])?.toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "shopId": shopId,
        "logoImg": logoImg,
        "title": title,
        "productId": productUuid,
        "productTitle": productTitle,
        "url": url,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

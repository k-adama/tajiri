class MainItemEntity {
  String? id;
  int? quantity;
  String? name;
  int? price;
  String? image;
  MainItemVariation? variant;

  MainItemEntity({
    this.id,
    this.quantity,
    this.name,
    this.price,
    this.image,
    this.variant,
  });
}

class MainItemVariation {
  String? id;
  int? itemId;
  String? name;
  int? price;

  MainItemVariation({
    this.id,
    this.itemId,
    this.name,
    this.price,
  });
}

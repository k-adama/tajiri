class RestaurantEntity {
  String? id;
  String? name;
  String? type;
  String? ownerId;
  String? logoUrl;
  String? coverUrl;
  String? contactEmail;
  String? contactPhone;
  String? address;
  String? city;
  String? country;
  String? currency;
  String? qrDetails;
  String? whatsapMessage;
  bool? listingEnable;
  String? listingType;
  bool? status;
  String? createdAt;
  String? updatedAt;

  RestaurantEntity(
      {this.id,
      this.name,
      this.type,
      this.ownerId,
      this.logoUrl,
      this.coverUrl,
      this.contactEmail,
      this.contactPhone,
      this.address,
      this.city,
      this.country,
      this.currency,
      this.qrDetails,
      this.whatsapMessage,
      this.listingEnable,
      this.listingType,
      this.status,
      this.createdAt,
      this.updatedAt});

  RestaurantEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    ownerId = json['ownerId'];
    logoUrl = json['logoUrl'];
    coverUrl = json['coverUrl'];
    contactEmail = json['contactEmail'];
    contactPhone = json['contactPhone'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    currency = json['currency'];
    qrDetails = json['qrDetails'];
    whatsapMessage = json['whatsapMessage'];
    listingEnable = json['listingEnable'];
    listingType = json['listingType'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['ownerId'] = ownerId;
    data['logoUrl'] = logoUrl;
    data['coverUrl'] = coverUrl;
    data['contactEmail'] = contactEmail;
    data['contactPhone'] = contactPhone;
    data['address'] = address;
    data['city'] = city;
    data['country'] = country;
    data['currency'] = currency;
    data['qrDetails'] = qrDetails;
    data['whatsapMessage'] = whatsapMessage;
    data['listingEnable'] = listingEnable;
    data['listingType'] = listingType;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

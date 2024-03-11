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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['ownerId'] = this.ownerId;
    data['logoUrl'] = this.logoUrl;
    data['coverUrl'] = this.coverUrl;
    data['contactEmail'] = this.contactEmail;
    data['contactPhone'] = this.contactPhone;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['qrDetails'] = this.qrDetails;
    data['whatsapMessage'] = this.whatsapMessage;
    data['listingEnable'] = this.listingEnable;
    data['listingType'] = this.listingType;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
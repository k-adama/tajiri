import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';

ListingType? checkListingType(UserEntity? user) {
  if (user?.restaurantUser?[0].restaurant?.listingEnable != true) {
    return null;
  }

  return user!.restaurantUser?[0].restaurant?.listingType == "TABLE"
      ? ListingType.table
      : ListingType.waitress;
}

enum ListingType {
  table,
  waitress;
}

import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';

class AppConstants {
  AppConstants._();

  /// shared preferences keys
  static const String orderCooking = 'COOKING';
  static const String orderCancelled = 'CANCELLED';
  static const String orderReady = 'READY';
  static const String orderNew = 'NEW';
  static const String orderAccepted = 'ACCEPTED_BY_RESTAURANT';
  static const String orderPaid = 'PAID';
  static const String orderDelivered = 'DELIVERED';
  static const String orderTakeByCourier = 'TAKEN_BY_COURIER';
  static const String clientTypeRestaurant = 'RESTAURANT';

  static const String keyLangSelected = 'keyLangSelected';
  static const String keyShopId = 'keyShopId';
  static const String keyRestaurantId = 'keyRestaurantId';
  static const String keyRestaurantName = 'keyRestaurantId';
  static const String keyCart = 'keyCart';
  static const String keyLocaleCode = 'keyLocaleCode';
  static const String keyFirstName = 'keyFirstName';
  static const String keyLastName = 'keyLastName';
  static const String keyProfileImage = 'keyProfileImage';
  static const String heroTagOrderHistory = 'heroTagOrderHistory';
  static const String keySavedStores = 'keySavedStores';
  static const String keySearchStores = 'keySearchStores';
  static const String keyViewedProducts = 'keyViewedProducts';
  static const String keyAddressSelected = 'keyAddressSelected';
  static const String keyAddressInformation = 'keyAddressInformation';
  static const String keyIsGuest = 'keyIsGuest';
  static const String keyUser = 'keyUserData';
  static const String keyLocalAddresses = 'keyLocalAddresses';
  static const String keyActiveAddressTitle = 'keyActiveAddressTitle';
  static const String keyLikedProducts = 'keyLikedProducts';
  static const String keySelectedCurrency = 'keySelectedCurrency';
  static const String keyCartProducts = 'keyCartProducts';
  static const String keyAppThemeMode = 'keyAppThemeMode';
  static const String keyWalletData = 'keyWalletData';
  static const String keyGlobalSettings = 'keyGlobalSettings';
  static const String keySettingsFetched = 'keySettingsFetched';
  static const String keyTranslations = 'keyTranslations';
  static const String keyLanguageData = 'keyLanguageData';
  static const String keyAuthenticatedWithSocial = 'keyAuthenticatedWithSocial';
  static const String keyLangLtr = 'keyLangLtr';

  /// hero tags
  static const String heroTagSelectUser = 'heroTagSelectUser';
  static const String heroTagSelectAddress = 'heroTagSelectAddress';
  static const String heroTagSelectCurrency = 'heroTagSelectCurrency';

  /// app strings
  static const String emptyString = '';

  /// api urls
  static const String drawingBaseUrl = 'https://api.openrouteservice.org';
  static const String apiUrl = 'https://api.dev.tajiri.io/v1';
  static const String googleApiKey = 'AIzaSyBgNvtPqsuKcgp26ukVPobjKw0Igx2dp5M';
  static const String privacyPolicyUrl = '$apiUrl/privacy-policy';
  static const String adminPageUrl = 'https://foodyman-single.vercel.app';
  static const String webUrl = 'https://foodyman-web-single.vercel.app';
  static const String dynamicPrefix = 'https://foodymansingle.page.link';
  static const String firebaseWebKey =
      'AIzaSyBgp-Y1H1fZwwfKuneopikYQcF1Kbcs0cg';
  static const String routingKey =
      '5b3ce3597851110001cf62480384c1db92764d1b8959761ea2510ac8';

  /// locales
  static const String localeCodeEn = 'en';

  /// location
  static const double demoLatitude = 41.304223;
  static const double demoLongitude = 69.2348277;
  static const double pinLoadingMin = 0.116666667;
  static const double pinLoadingMax = 0.611111111;

  static const Duration timeRefresh = Duration(seconds: 30);
  static const Duration productCartSnackbarDuration =
      Duration(days: 6000000000000000);

  static bool getStatusOrderInProgressOrDone(
      OrdersDataEntity order, String status) {
    bool checking = false;
    switch (status) {
      case "IN_PROGRESS":
        if (order.status != "PAID" && order.status != "CANCELLED")
          checking = true;
        break;
      case "DONE":
        if (order.status == "PAID" || order.status == "CANCELLED")
          checking = true;
        break;
    }

    return checking;
  }

  static String getStatusInFrench(OrdersDataEntity order) {
    String status = "";
    switch (order.status) {
      case orderCooking:
        status = "En Cuisine";
        break;
      case orderCancelled:
        status = "Annulée";
        break;
      case orderReady:
        status = "Prête";
        break;
      case orderNew:
        status = "Nouvelle";
        break;
      case orderAccepted:
        status = "Acceptée";
        break;
      case orderPaid:
        status = "Payée";
        break;
      case orderDelivered:
        status = "Livrée";
        break;
      case orderTakeByCourier:
        status = "En livraison";
        break;
    }

    return status;
  }
}

enum ShopStatus { notRequested, newShop, edited, approved, rejected }

enum UploadType {
  extras,
  brands,
  categories,
  shopsLogo,
  shopsBack,
  products,
  reviews,
  users,
}

enum PriceFilter { byLow, byHigh }

enum ListAlignment { singleBig, vertically, horizontally }

enum ExtrasType { color, text, image }

enum DeliveryTypeEnum { delivery, pickup }

enum ShippingDeliveryVisibilityType {
  cantOrder,
  onlyDelivery,
  onlyPickup,
  both,
}

enum OrderStatus { open, accepted, ready, onWay, delivered, canceled }

enum CouponType { fix, percent }

enum MessageOwner { you, partner }

enum BannerType { banner, look }

enum LookProductStockStatus { outOfStock, alreadyAdded, notAdded }

enum SingingCharacter { Oui, Non }

enum TableOrWaitress { WAITRESS, TABLE }

enum ChairPosition { top, bottom, left, right }

List<Map<String, dynamic>> SWIPERDATA = [
  {
    "title": "Prise de commande",
    "content": "simplifiée",
    "secondcontent": "& rapide",
    "image": "assets/svgs/pos_1.svg"
  },
  {
    "title": "Gestion du stock",
    "content": "optimisée",
    "secondcontent": "& centralisée",
    "image": "assets/svgs/gestion de stock 1.svg"
  },
  {
    "title": "Rapport de vente",
    "content": "précis",
    "secondcontent": "& détaillé",
    "image": "assets/svgs/rapport de vente 1.svg"
  }
];

List<Map<String, dynamic>> VIDEODEMO = [
  {
    "id": 0,
    "miniature": "assets/images/miniature video_Plan de travail 1.png",
    "video": "assets/videos/Comment se connecter dans tajiri.mp4",
  },
  {
    "id": 1,
    "miniature": "assets/images/miniature video-02.png",
    "video": "assets/videos/Comment passer une commande.mp4",
  },
  {
    "id": 2,
    "miniature": "assets/images/miniature video-03.png",
    "video": "assets/videos/Comment modifier une commande enregistrée.mp4",
  },
  {
    "id": 3,
    "miniature": "assets/images/miniature video-04.png",
    "video": "assets/videos/Comment générer un rapport de vente.mp4",
  }
];

List<Map<String, dynamic>> PAIEMENTS = [
  {
    'name': "Cash",
    'id': "d8b8d45d-da79-478f-9d5f-693b33d654e6",
    'icon': "assets/images/cash.png",
  },
  {
    'name': "OM",
    'id': "7be4b57e-02a6-4c4f-b3a0-13597554fb5d",
    'icon': "assets/images/omoney.png",
  },
  {
    'name': "MTN M",
    'id': "7af1ade3-8079-48ea-90bf-23cc06ea66ca",
    'icon': "assets/images/momo.png",
  },
  {
    'name': "Wave",
    'id': "6efbbe2d-3066-4a03-b52c-cb28f1990f44",
    'icon': "assets/images/wave.png",
  },
  {
    'name': "TPE",
    'id': "5b5a6cc7-dd4f-4b9f-aef1-3cc5ccac30bf",
    'icon': "assets/images/tpe24.png",
  },
  {
    'name': "Autre",
    'id': "0017bf5f-4530-42dd-9dcd-7bd5067c757a",
    'icon': "assets/images/card24.png",
  },
];

final tabs = [
  const Tab(text: "Toutes"),
  const Tab(text: "En cours"),
  const Tab(text: "Terminées"),
];

final editFoodTab = [
  const Tab(
    text: 'Produit principal',
  ),
  const Tab(
    text: 'Variant',
  ),
];

const WAVE_ID = "6efbbe2d-3066-4a03-b52c-cb28f1990f44";

List<String> monthNames = [
  "Jan", //0
  "Fév", //1
  "Mar", //2
  "Avr", //3
  "Mai", //4
  "Jui", //5
  "Juil", //6
  "Aoû", //7
  "Sep", //8
  "Oct", //9
  "Nov", //10
  "Déc", //11
];
List<String> weekdays = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];

List<double> weeklySummary = [
  104.20,
  2.50,
  42.42,
  10.50,
  100.20,
  88.99,
  90.10,
];
const List<Map<String, dynamic>> SETTLE_ORDERS = [
  {
    'name': 'Sur place',
    'id': 'ON_PLACE',
    'icon':
        "assets/svgs/sur_place.svg", // Assuming OnPlace is a Dart class or a variable holding an icon
  },
  {
    'name': 'À emporter',
    'id': 'TAKE_AWAY',
    'icon':
        "assets/svgs/Emporter.svg", // Assuming TakeAway is a Dart class or a variable holding an icon
  },
  {
    'name': 'À livrer',
    'id': 'DELIVERED',
    'icon': 'assets/svgs/delivery.svg',
  },
];

const List<Map<String, dynamic>> WAITRESS = [
  {'id': '1', 'name': 'Alain', 'sexe': 'male'},
  {'id': '2', 'name': 'Michelle', 'sexe': 'female'},
  {'id': '3', 'name': 'Léa', 'sexe': 'female'},
  {'id': '4', 'name': 'Prince', 'sexe': 'male'}
];

const List<Map<String, dynamic>> TABLE = [
  {'id': '1', 'name': 'Table 1'},
  {'id': '2', 'name': 'Table 2'},
  {'id': '3', 'name': 'Table 3'},
  {'id': '4', 'name': 'Table 4'}
];

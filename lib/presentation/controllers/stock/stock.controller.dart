import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/extensions/inventory.extension.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/stock_inventory.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_sdk/src/dto/inventory.dto.dart';

class StockController extends GetxController {
  late Inventory food;
  List<Inventory> foodsInventory = [];
  List<StockInventoryEntity> stockInventory = [];
  bool isProductLoading = true;
  bool checkboxstatus = false;
  String searchProductText = "";
  int selectIndex = 0;
  static final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  final restaurantId = user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() async {
    fetchFoodsInventory();
    super.onReady();
  }

  Future<void> fetchFoodsInventory() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      try {
        final inventories = await tajiriSdk.inventoryService.getInventory();
        foodsInventory.assignAll(inventories);
        isProductLoading = false;
        update();
      } catch (e) {
        isProductLoading = false;
        update();
      }
    }
  }

  Future<void> _updateChangeStock(
      String id, int stock, String type, context) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        InventoryDto inventoryDto =
            InventoryDto(productId: id, quantity: stock, type: type);
        await tajiriSdk.inventoryService.makeInventory(inventoryDto);
      } catch (e) {
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
      }
    }
  }

  void updateStockMovement(
      BuildContext context, String id, int stock, String type) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        InventoryDto inventoryDto =
            InventoryDto(productId: id, quantity: stock, type: type);
        await tajiriSdk.inventoryService.makeInventory(inventoryDto);
        fetchFoodsInventory();
        AppHelpersCommon.showAlertDialog(
          context: context,
          canPop: false,
          child: SuccessfullDialog(
            isCustomerAdded: true,
            haveButton: false,
            title: "L'ajustement a été effectué avec succès",
            content: "Le stock du produit a été mis à jour.",
            svgPicture: "assets/svgs/stock 1.svg",
            redirect: () {
              Get.close(2);
            },
          ),
        );
      } catch (e) {
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          e.toString(),
        );
      }
    }
  }

  updateQuantity(int quantity, Inventory foodIventory) {
    final indexFood = stockInventory.indexWhere(
        (stockInventory) => stockInventory.idFoodInventory == foodIventory.id);
    if (indexFood != -1) {
      stockInventory[indexFood].quantity = quantity;
      update();
    } else {
      stockInventory.add(foodIventory.toStockInventory(quantity));
      update();
    }
  }

  updateStock(BuildContext context) async {
    final newStockInventory = stockInventory
        .map((item) => item)
        .toList()
        .where((food) => food.quantity > 0);

    if (newStockInventory.isEmpty) {
      return;
    }
    isProductLoading = true;
    update();
    await Future.wait(newStockInventory.map((e) async {
      return await _updateChangeStock(
          e.idFoodInventory!, e.quantity, "SUPPLY", context);
    }));
    try {
      Mixpanel.instance.track("Stock Inventory Supply", properties: {
        "Products": newStockInventory.map((item) {
          return {
            'Product Name': item.nameFoodInventory,
            'Old Quantity': item.oldquantity,
            'Add Quantity': item.quantity
          };
        }).toList()
      });
    } catch (e) {
      print("Mixpanel error : $e");
    }
    await fetchFoodsInventory();
    AppHelpersCommon.showAlertDialog(
      context: context,
      canPop: false,
      child: SuccessfullDialog(
        isCustomerAdded: true,
        haveButton: false,
        title: "L'approvisionnement a été effectué avec succès !",
        content: "Les stocks ont été mis à jour.",
        svgPicture: "assets/svgs/stock 1.svg",
        redirect: () {
          Get.close(1);
        },
      ),
    );
  }

  void searchFilter(String search, bool checkbox) {
    if (checkbox) {
      foodsInventory.clear();
    }
    update();
    if (search.isEmpty) {
      fetchFoodsInventory();
      update();
    } else {
      final nameRecherch = search.toLowerCase();
      final filteredFoods = foodsInventory.where((item) {
        final foodName = item.name.toLowerCase();
        return foodName.startsWith(nameRecherch);
      }).toList();

      if (checkbox) {
        foodsInventory.assignAll(filteredFoods);
      } else {
        foodsInventory.assignAll(filteredFoods);
      }

      update();
    }
  }

  lastSupply(List<InventoryHistory>? stockList) {
    if (stockList == null) return;

    List<InventoryHistory>? supplyUnique = stockList.map((e) => e).toList()
      ..where((element) => element.type == "SUPPLY")
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (supplyUnique.isEmpty) return 0;
    return supplyUnique[0].addQuantity;
  }

  lastMove(List<InventoryHistory>? stockList) async {
    if (stockList == null) return "";
    List<InventoryHistory> supplyUnique = stockList.map((e) => e).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (supplyUnique.isEmpty) return "0";

    InventoryHistory value = supplyUnique[0];
    String time = formatDateTime(value.createdAt);

    String? userId = value.userId;
    // Get Staff
    Staff staff = await tajiriSdk.staffService.getStaff(userId);
    if (staff.lastname.isEmpty || staff.firstname.isEmpty) return '$time ';

    return '$time par ${staff.lastname} ${staff.lastname}';
  }

  List<InventoryHistory>? getSortList(List<InventoryHistory>? stockList) {
    if (stockList == null) return null;
    List<InventoryHistory>? sortStockList = stockList.map((e) => e).toList()
      ..sort((a, b) {
        DateTime createdAtA = a.createdAt;
        DateTime createdAtB = b.createdAt;
        return createdAtB.compareTo(createdAtA);
      });

    return sortStockList;
  }

  String convertToDate(dynamic datestring) {
    DateTime parseToDate;
    if (datestring is DateTime) {
      parseToDate = datestring;
    } else {
      parseToDate = DateTime.parse(datestring ?? "");
    }
    String formattedTime = DateFormat.Hm().format(parseToDate);
    return formattedTime;
  }

  formatDateTime(DateTime date) {
    String formattedTime = DateFormat.Hm().format(date);
    return formattedTime;
  }

  // see history
  getTypeMove(InventoryHistory? stockItem) {
    if (stockItem?.type != null) {
      if (stockItem?.type == "STOCK_ADJUSTMENT") return "Ajustement de stock";
    }
    return "Approvisionnement de stock";
  }

  // see history
  Future<String> getUser(InventoryHistory stockItem) async {
    Staff staff = await tajiriSdk.staffService.getStaff(stockItem.userId);
    if (staff != null) {
      return 'par ${staff.lastname} ${staff.firstname}';
    }
    return "";
  }

  getQuantity(InventoryHistory? stockItem) {
    if (stockItem?.type != null) {
      if (stockItem?.type == "STOCK_ADJUSTMENT") {
        int oldQuantity = stockItem?.oldQuantity ?? 0;
        int addQuantity = stockItem?.addQuantity ?? 0;
        int? difference = calculateQuantity(stockItem);
        return oldQuantity > addQuantity
            ? '-${difference}'
            : addQuantity > oldQuantity
                ? '+${difference}'
                : '${0}';
      }
    }
    return '+${stockItem?.addQuantity}';
  }

  calculateQuantity(InventoryHistory? stockItem) {
    int oldQuantity = stockItem?.oldQuantity ?? 0;
    int addQuantity = stockItem?.addQuantity ?? 0;
    if (oldQuantity > addQuantity) {
      return oldQuantity - addQuantity;
    } else if (addQuantity > oldQuantity) {
      return addQuantity - oldQuantity;
    }
    return 0;
  }

  formatDate(InventoryHistory stockItem) {
    if (stockItem.createdAt != null) {
      DateTime dateFormat = stockItem.createdAt;
      String date = dateWithFormatWithoutGmt(dateFormat);
      return date;
    }
    return "";
  }

  dateWithFormatWithoutGmt(DateTime date) {
    //'EEE, d MMM yyyy HH:mm:ss'
    var formatter = DateFormat('d MMM HH:mm');
    var dateFormat = formatter.format(date);
    return dateFormat;
  }
}

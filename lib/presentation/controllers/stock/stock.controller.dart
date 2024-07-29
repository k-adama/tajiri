import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/data/repositories/products/products.repository.dart';
import 'package:tajiri_pos_mobile/data/repositories/stock/stock.repository.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/stock_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';

class StockController extends GetxController {
  List<Product> foods = List<Product>.empty().obs;
  List<Product> foodsInit = List<Product>.empty().obs;
  List<Map<String, dynamic>> foodsInventory = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> foodsInventoryInit = <Map<String, dynamic>>[];
  bool isProductLoading = true;
  final ProductsRepository _productsRepository = ProductsRepository();
  final StockRepository _stockRepository = StockRepository();
  final dynamic user = LocalStorageService.instance.get(UserConstant.keyUser);
  bool checkboxstatus = false;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    fetchFoods();
    super.onReady();
  }

  Future<void> fetchFoods() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final response = await _productsRepository.getFoods();

      response.when(
        success: (data) async {
          foods.assignAll(data!);
          foodsInit.assignAll(data);
          foodsInventory = data.map((item) {
            return {
              'id': item.id,
              'imageUrl': item.imageUrl,
              'name': item.name,
              'quantityAdd': 0,
            };
          }).toList();
          foodsInventoryInit.assignAll(foodsInventory);
          isProductLoading = false;
          update();
        },
        failure: (failure, status) {},
      );
    }
  }

  Future<Product?> _updateChangeStock(String id, int stock, String type) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        await _stockRepository.updateStockMovement(id, stock, type);
      } catch (e) {}
    }
    return null;
  }

  void updateStockMovement(
      BuildContext context, String id, int stock, String type) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      final response =
          await _stockRepository.updateStockMovement(id, stock, type);

      response.when(
        success: (data) {
          fetchFoods();
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
        },
        failure: (failure, status) {},
      );
    }
  }

  updateQuantity(int quantity, dynamic foodUpdate) {
    final indexFood =
        foodsInventory.indexWhere((food) => food['id'] == foodUpdate['id']);
    foodsInventory[indexFood]['quantityAdd'] = quantity;
  }

  updateStock(BuildContext context) async {
    final newFoods = foodsInventory
        .map((item) => item)
        .toList()
        .where((food) => food['quantityAdd'] > 0);

    if (newFoods.isEmpty) return;
    isProductLoading = true;
    update();

    await Future.wait(newFoods.map((e) async {
      return await _updateChangeStock(
        e['id'],
        e['quantityAdd'],
        'SUPPLY',
      );
    }));

    Mixpanel.instance.track("Stock Inventory Supply", properties: {
      "Products": newFoods.map((item) {
        return {
          'Product Name': item['name'],
          'Old Quantity': item['quantity'],
          'Add Quantity': item['quantityAdd']
        };
      }).toList()
    });

    await fetchFoods();
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
    } else {
      foods.clear();
    }
    update();

    if (search.isEmpty) {
      foods.addAll(foodsInit);
      foodsInventory.assignAll(foodsInit.map((item) {
        return {
          'id': item.id,
          'imageUrl': item.imageUrl,
          'name': item.name,
          'quantityAdd': 0,
        };
      }).toList());
      update();
    } else {
      final nameRecherch = search.toLowerCase();
      final filteredFoods = foodsInit.where((item) {
        final foodName = item.name!.toLowerCase();
        final categoryName = item.category!.name!.toLowerCase();
        return foodName.startsWith(nameRecherch) ||
            categoryName.startsWith(nameRecherch);
      }).toList();

      if (checkbox) {
        foodsInventory.assignAll(filteredFoods.map((item) {
          return {
            'id': item.id,
            'imageUrl': item.imageUrl,
            'name': item.name,
            'quantityAdd': 0,
          };
        }).toList());
      } else {
        foods.addAll(filteredFoods);
      }
      update();
    }
  }

  lastSupply(List<StockDataEnty>? stockList) {
    if (stockList == null) return;

    List<StockDataEnty>? supplyUnique = stockList.map((e) => e).toList()
      ..where((element) => element.type == "SUPPLY")
      ..sort((a, b) => DateTime.parse(b.createdAt ?? "")
          .compareTo(DateTime.parse(a.createdAt ?? "")));

    if (supplyUnique.isEmpty) return 0;
    return supplyUnique[0].addQuantity;
  }

  lastMove(List<StockDataEnty>? stockList) {
    if (stockList == null) return;
    List<StockDataEnty> supplyUnique = stockList.map((e) => e).toList()
      ..sort((a, b) => DateTime.parse(b.createdAt ?? "")
          .compareTo(DateTime.parse(a.createdAt ?? "")));

    if (supplyUnique.isEmpty) return 0;

    StockDataEnty value = supplyUnique[0];
    String time = convertToDate(value.createdAt ?? 0);

    if (value.user?.lastname == null || value.user?.firstname == null)
      return '${time} ';

    return '${time} par ${value.user?.lastname ?? ""} ${value.user?.firstname ?? ""}';
  }

  getSortList(List<StockDataEnty>? stockList) {
    if (stockList == null) return;
    List<StockDataEnty>? sortStockList = stockList.map((e) => e).toList()
      ..sort((a, b) => DateTime.parse(b.createdAt ?? "")
          .compareTo(DateTime.parse(a.createdAt ?? "")));

    return sortStockList;
  }

  convertToDate(dynamic datestring) {
    DateTime parseToDate = DateTime.parse(datestring ?? "");
    String formattedTime = DateFormat.Hm().format(parseToDate);
    return formattedTime;
  }

  // see history
  getTypeMove(StockDataEnty? stockItem) {
    if (stockItem?.type != null) {
      if (stockItem?.type == "STOCK_ADJUSTMENT") return "Ajustement de stock";
    }
    return "Approvisionnement de stock";
  }

  // see history
  getUser(StockDataEnty? stockItem) {
    if (stockItem?.user != null) {
      return 'par ${stockItem?.user?.lastname} ${stockItem?.user?.firstname}';
    }
    return "";
  }

  getQuantity(StockDataEnty? stockItem) {
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

  calculateQuantity(StockDataEnty? stockItem) {
    int oldQuantity = stockItem?.oldQuantity ?? 0;
    int addQuantity = stockItem?.addQuantity ?? 0;
    if (oldQuantity > addQuantity) {
      return oldQuantity - addQuantity;
    } else if (addQuantity > oldQuantity) {
      return addQuantity - oldQuantity;
    }
    return 0;
  }

  formatDate(StockDataEnty? stockItem) {
    if (stockItem?.createdAt != null) {
      DateTime dateFormat = DateTime.parse(stockItem?.createdAt ?? "");
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

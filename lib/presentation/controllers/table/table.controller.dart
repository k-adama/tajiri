import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart' as taj_sdk;
import 'package:tajiri_sdk/tajiri_sdk.dart';

class TableController extends GetxController {
  RxList<taj_sdk.Table> tableListData = List<taj_sdk.Table>.empty().obs;
  bool isLoadingTable = false;
  bool isLoadingEdetingTable = false;
  bool isLoadingDeleteTable = false;
  String tableName = "";
  String tableDescription = "";
  String tableNumberOfPlace = "";
  String? tableId;
  late taj_sdk.Table newTable;
  Rx<taj_sdk.Table?> selectedTable = Rx<taj_sdk.Table?>(null);

  final user = AppHelpersCommon.getUserInLocalStorage();
  String? get restaurantId => user?.restaurantId;
  final tajiriSdk = taj_sdk.TajiriSDK.instance;

  @override
  void onReady() async {
    await fetchTables();
    super.onReady();
  }

  clearSelectTable() {
    selectedTable.value = null;
    // ordersController.filterByTable(null);
  }

  Future<void> fetchTables() async {
    clearSelectTable();
    if (restaurantId == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingTable = true;
      update();
      try {
        isLoadingTable = true;
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId!);
        tableListData.assignAll(result);
        isLoadingTable = false;
        update();
      } catch (e) {
        isLoadingTable = false;
        update();
      }
    }
  }

  Future<void> saveTable(BuildContext context, String tableName,
      String tableDescription, String tableNumberOfPlace) async {
    final persons = int.tryParse(tableNumberOfPlace);
    if (tableName.isEmpty || tableNumberOfPlace.isEmpty) {
      isLoadingTable = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez remplir tous les champs obligatoires",
      );
    }

    if (persons == null) {
      isLoadingTable = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez remplir tous les champs obligatoires",
      );
    }
    final taj_sdk.CreateTableDto createTableDto = taj_sdk.CreateTableDto(
        name: tableName,
        description: tableDescription,
        persons: persons,
        imageUrl: "https://image.com",
        status: true,
        restaurantId: restaurantId!);

    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingTable = true;
        update();
        final result =
            await tajiriSdk.tablesService.createTable(createTableDto);

        newTable = result;

        isLoadingTable = false;
        update();

        AppHelpersCommon.showAlertDialog(
          context: context,
          canPop: false,
          child: SuccessfullDialog(
            haveButton: false,
            isCustomerAdded: false,
            title: "Table créée",
            content: "La $tableName a bien été ajouté",
            svgPicture: "assets/svgs/table 1.svg",
            redirect: () {
              Get.close(2);
            },
          ),
        );
        fetchTablesById(result.id);
        tableInitialState();
      } catch (e) {
        isLoadingTable = false;
        update();
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
      }
    }
  }

  Future<void> updateTable(BuildContext context, String tableId) async {
    final persons = int.tryParse(tableNumberOfPlace);

    if (persons == null) {
      isLoadingEdetingTable = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez remplir tous les champs obligatoires",
      );
    }
    final UpdateTableDto updateTableDto = UpdateTableDto(
      name: tableName,
      description: tableDescription,
      persons: persons,
    );

    try {
      final result =
          await tajiriSdk.tablesService.updateTable(tableId, updateTableDto);
      isLoadingEdetingTable = false;
      update();
      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          haveButton: false,
          isCustomerAdded: false,
          title: "Table modifiée",
          content: "La $tableName a bien été modifiée",
          svgPicture: "assets/svgs/table 1.svg",
          redirect: () {
            Get.close(2);
          },
        ),
      );
      updateTableList(result);
      tableInitialState();
      isLoadingEdetingTable = false;
      update();
    } catch (e) {
      isLoadingEdetingTable = false;
      update();
      AppHelpersCommon.showBottomSnackBar(
        Get.context!,
        Text(e.toString()),
        const Duration(seconds: 2),
        true,
      );
    }
  }

  Future<void> deleteTable(BuildContext context, String tableId) async {
    if (tableId.isEmpty) return;
    try {
      isLoadingDeleteTable = true;
      update();

      await tajiriSdk.tablesService.deleteTable(tableId);
      isLoadingDeleteTable = false;
      update();
      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          haveButton: false,
          isCustomerAdded: false,
          title: "Table supprimée",
          content: "La $tableName a bien été supprimée",
          svgPicture: "assets/svgs/table 1.svg",
          redirect: () {
            Get.close(2);
          },
        ),
      );
      tableListData.removeWhere((element) => element.id == tableId);
      update();
    } catch (e) {
      isLoadingDeleteTable = false;
      update();
      print("Error delete table $e");
    }
  }

  Future<void> fetchTablesById(String? id) async {
    print("=======fetchTablesById========");
    clearSelectTable();
    if (restaurantId == null) {
      return;
    }
    if (id == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingTable = true;
      update();
      try {
        isLoadingTable = true;
        update();
        final result = await tajiriSdk.tablesService.getTable(id);
        updateTableList(result);
        isLoadingTable = false;
        update();
      } catch (e) {
        isLoadingTable = false;
        update();
      }
    }
  }

  void updateTableList(taj_sdk.Table newTable) {
    clearSelectTable();
    final indexInit =
        tableListData.indexWhere((table) => table.id == newTable.id);
    print("update order list $indexInit");
    if (indexInit != -1) {
      // Replace the old table with the new table in tablesInit
      tableListData[indexInit] = newTable;
    } else {
      // Add the new table to tableInit if it doesn't exist
      tableListData.insert(0, newTable);
    }
  }

  void tableInitialState() {
    isLoadingTable = false;
    tableName = "";
    tableDescription = "";
    tableNumberOfPlace = "";
    update();
  }

  void setTableName(String text) {
    tableName = text.trim();
    update();
  }

  void setTableDescription(String text) {
    tableDescription = text.trim();
    update();
  }

  void setTableNumberPlace(String text) {
    tableNumberOfPlace = text.trim();
    update();
  }

  changeSelectTable(taj_sdk.Table? newValue) {
    selectedTable.value = newValue!;
    update();
  }
}

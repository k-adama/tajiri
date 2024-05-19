import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/table.entiy.dart';
import 'package:tajiri_pos_mobile/data/repositories/tables/tables.repository.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';

class TableController extends GetxController {
  final TablesRepository _tablesRepository = TablesRepository();
  RxList<TableEntity> tableListData = List<TableEntity>.empty().obs;
  bool isLoadingTable = false;
  bool isLoadingEdetingTable = false;
  bool isLoadingDeleteTable = false;
  bool isListView = true;
  String tableName = "";
  String tableDescription = "";
  String tableNumberOfPlace = "";
  String? tableId;
  TableEntity newTable = TableEntity();
  Rx<TableEntity?> selectedTable = Rx<TableEntity?>(null);
  // OrdersController ordersController = Get.find();

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
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingTable = true;
      update();
      final response = await _tablesRepository.getTables();
      response.when(
        success: (data) async {
          tableListData.assignAll(data!);
          isLoadingTable = false;
          update();
        },
        failure: (failure, status) {
          isLoadingTable = false;
          update();
        },
      );
    }
  }

  changeSelectTable(TableEntity? newValue) {
    selectedTable.value = newValue!;
    update();
  }

  Future<void> saveTable(BuildContext context, String tableName,
      String tableDescription, String tableNumberOfPlace) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingTable = true;
      update();
      final user = AppHelpersCommon.getUserInLocalStorage();
      final restaurantId = user?.role?.restaurantId;
      if (restaurantId == null) {
        print("====${restaurantId} null====");
        return;
      }

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
      Map<String, dynamic> requestData = {
        'name': tableName,
        'description': tableDescription,
        'persons': persons,
        "status": true,
        "restaurantId": restaurantId,
      };

      final response = await _tablesRepository.createTable(requestData);
      response.when(success: (data) async {
        newTable = data!;
        update();
        tableInitialState();

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
        fetchTables();
      }, failure: (failure, status) {
        isLoadingTable = false;
        update();
      });
    }
  }

  Future<void> updateTableName(BuildContext context, String tableId) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingEdetingTable = true;
      update();
      try {
        final persons = int.tryParse(tableNumberOfPlace);

        if (persons == null) {
          isLoadingEdetingTable = false;
          update();
          return AppHelpersCommon.showCheckTopSnackBarInfoForm(
            context,
            "Veuillez remplir tous les champs obligatoires",
          );
        }

        Map<String, dynamic> updateData = {
          'name': tableName,
          'description': tableDescription,
          'persons': persons,
        };

        final response =
            await _tablesRepository.updateTable(updateData, tableId);

        response.when(success: (data) {
          tableId = "";
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
          fetchTables();
          tableInitialState();
          isLoadingEdetingTable = false;
          update();
        }, failure: (failure, status) {
          AppHelpersCommon.showCheckTopSnackBar(
            context,
            status.toString(),
          );
          isLoadingEdetingTable = false;
          tableId = "";
          update();
        });
      } catch (e) {
        print(e);
        isLoadingEdetingTable = false;
        update();
      }
    }
  }

  Future<void> deleteTableName(BuildContext context, String tableId) async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingDeleteTable = true;
      update();
      final response = await _tablesRepository.deleteTable(tableId);
      response.when(success: (data) {
        tableId = "";
        isLoadingDeleteTable = false;
        update();
      }, failure: (failure, status) {
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
        fetchTables();
        tableId = "";
        isLoadingDeleteTable = false;
        update();
      });
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
}

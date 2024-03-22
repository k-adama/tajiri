import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/order.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/select_dropdown.button.dart';

class SelectTableComponent extends StatefulWidget {
  const SelectTableComponent({super.key});

  @override
  State<SelectTableComponent> createState() => _SelectTableComponentState();
}

class _SelectTableComponentState extends State<SelectTableComponent> {
  // final OrdersController _ordersController = Get.find();
  final posController = Get.find<PosController>();
  final tableController = Get.find<TableController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SelectDropDownButton(
        value: tableController.selectedTable.value,
        containerColor: posController.containerColor,
        tableListData: tableController.tableListData.value,
        onChanged: (TableModel? newValue) {
          Mixpanel.instance.track("Change Table", properties: {
            "Old Value": posController.tableCurrentId,
            "New Value": newValue?.id
          });
          tableController.changeSelectTable(newValue);
          int index = tableController.tableListData.indexOf(newValue);
          posController.containerColor =
              Style.colors[index % Style.colors.length];
          if (newValue != null) {
            posController.tableCurrentId = newValue.id;
            // _ordersController.filterByTable(posController.tableCurrentId);
          } else {
            // _ordersController.filterByTable(null);
          }
        },
        hinText: "Toutes les tables",
      );
    });
  }
}

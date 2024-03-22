import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/select_table.widget.dart';

class SelectTableComponent extends StatefulWidget {
  const SelectTableComponent({super.key});

  @override
  State<SelectTableComponent> createState() => _SelectTableComponentState();
}

class _SelectTableComponentState extends State<SelectTableComponent> {
  // final OrdersController _ordersController = Get.find();
  final posController = Get.find<PosController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(builder: (tableController) {
      return SelectTableWidget(
          value: tableController.selectedTable.value,
          containerColor: posController.containerColor,
          tableListData: tableController.tableListData,
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
          });
    });
  }
}

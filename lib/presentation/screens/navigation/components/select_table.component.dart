import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/select_dropdown.button.dart';
import 'package:tajiri_sdk/src/models/table.model.dart' as taj_sdk;

class SelectTableComponent extends StatefulWidget {
  const SelectTableComponent({super.key});

  @override
  State<SelectTableComponent> createState() => _SelectTableComponentState();
}

class _SelectTableComponentState extends State<SelectTableComponent> {
  final ordersController = Get.find<OrdersController>();
  final posController = Get.find<PosController>();
  final tableController = Get.find<TableController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SelectDropDownButton<taj_sdk.Table>(
        value: tableController.selectedTable.value,
        containerColor: posController.containerColor,
        items: [
          DropdownMenuItem<taj_sdk.Table>(
            value: null,
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Style.dotColor,
              ),
              child: const Row(
                children: [
                  SizedBox(width: 14),
                  SizedBox(
                    width: 100,
                    child: Text(
                      "Toutes les tables",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...tableController.tableListData.value.map((taj_sdk.Table item) {
            int index = tableController.tableListData.value.indexOf(item);
            return DropdownMenuItem<taj_sdk.Table>(
              value: item,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Style.colors[index % Style.colors.length],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
        onChanged: (taj_sdk.Table? newValue) {
          Mixpanel.instance.track("Change Table", properties: {
            "Old Value": posController.tableCurrentId,
            "New Value": newValue?.id
          });
          tableController.changeSelectTable(newValue);
          int index = tableController.tableListData.indexOf(newValue);
          posController.containerColor = newValue == null
              ? Style.dotColor
              : Style.colors[index % Style.colors.length];

          posController.tableCurrentId = newValue?.id;
          ordersController.filterByTable(posController.tableCurrentId);
        },
        hinText: "Toutes les tables",
      );
    });
  }
}

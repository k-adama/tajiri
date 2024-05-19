import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/table.entiy.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/select_dropdown.button.dart';

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
      return SelectDropDownButton<TableEntity>(
        value: tableController.selectedTable.value,
        containerColor: posController.containerColor,
        items: tableController.tableListData.value.map((TableEntity item) {
          int index = tableController.tableListData.value.indexOf(item);
          return DropdownMenuItem<TableEntity>(
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
                      item.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (TableEntity? newValue) {
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
            ordersController.filterByTable(posController.tableCurrentId);
          } else {
            ordersController.filterByTable(null);
          }
        },
        hinText: "Toutes les tables",
      );
    });
  }
}

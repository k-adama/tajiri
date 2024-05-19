import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/waitress.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/select_dropdown.button.dart';

class SelectWaitressComponent extends StatefulWidget {
  const SelectWaitressComponent({super.key});

  @override
  State<SelectWaitressComponent> createState() =>
      _SelectWaitressComponentState();
}

class _SelectWaitressComponentState extends State<SelectWaitressComponent> {
  final OrdersController ordersController = Get.find();
  final PosController posController = Get.find();
  final WaitressController waitressController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SelectDropDownButton<WaitressEntity>(
        value: waitressController.selectedWaitress.value,
        containerColor: posController.containerColor,
        items: waitressController.waitress.value.map((WaitressEntity item) {
          int index = waitressController.waitress.value.indexOf(item);
          return DropdownMenuItem<WaitressEntity>(
            value: item,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Style.colors[index % Style.colors.length],
              ),
              child: Row(
                children: [
                  10.horizontalSpace,
                  item.gender == 'MALE'
                      ? SvgPicture.asset('assets/svgs/noto_man.svg')
                      : SvgPicture.asset('assets/svgs/noto_woman.svg'),
                  8.horizontalSpace,
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${item.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (WaitressEntity? newValue) {
          Mixpanel.instance.track("Change Waitress", properties: {
            "Old Value": posController.waitressCurrentId,
            "New Value": newValue?.id
          });
          setState(() {
            waitressController.selectedWaitress.value = newValue!;
            int index = waitressController.waitress.indexOf(newValue);
            posController.containerColor =
                Style.colors[index % Style.colors.length];
          });

          if (newValue != null) {
            posController.waitressCurrentId = newValue.id;
            ordersController.filterByWaitress(posController.waitressCurrentId);
          } else {
            ordersController.filterByWaitress(null);
          }
        },
        hinText: "Tous les serveurs",
      );
    });
  }
}

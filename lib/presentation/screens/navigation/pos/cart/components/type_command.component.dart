import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';

class TypeCommandComponent extends StatefulWidget {
  const TypeCommandComponent({super.key});

  @override
  State<TypeCommandComponent> createState() => _TypeCommandComponentState();
}

class _TypeCommandComponentState extends State<TypeCommandComponent> {
  final posController = Get.find<PosController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: SETTLE_ORDERS.length,
        itemBuilder: (context, index) {
          final settleOrder = SETTLE_ORDERS[index];

          return Obx(() {
            final isSelect =
                posController.settleOrderId.value == settleOrder['id'];
            return TypeCommandItem(
              settleOrder: settleOrder,
              onTap: () {
                posController.settleOrderId.value = settleOrder['id'];
              },
              isSelect: isSelect,
            );
          });
        },
      ),
    );
  }
}

class TypeCommandItem extends StatelessWidget {
  final Map<String, dynamic> settleOrder;
  final VoidCallback onTap;
  final bool isSelect;
  const TypeCommandItem(
      {super.key,
      required this.settleOrder,
      required this.onTap,
      required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(settleOrder['id']),
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            elevation: !isSelect ? 0 : 15,
            child: Container(
              height: !isSelect ? 70.h : 90.h,
              width: 90.w,
              decoration: BoxDecoration(
                  color: !isSelect ? Style.lightBlue : Style.white,
                  borderRadius: !isSelect
                      ? BorderRadius.circular(1)
                      : BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: !isSelect ? 34.w : 35.w,
                      height: !isSelect ? 30.h : 35.h,
                      child: SvgPicture.asset(
                        settleOrder['icon'],
                        height: !isSelect ? 30.h : 50.h,
                      ),
                    ),
                    Text(
                      settleOrder['name'],
                      style: Style.interNormal(size: !isSelect ? 10.sp : 11.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

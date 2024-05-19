import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class OrderStatusButtonComponent extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final bool isGrised;

  final VoidCallback onTap;
  OrderStatusButtonComponent(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.onTap,
      this.isGrised = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: isGrised == true
                ? null
                : () {
                    Slidable.of(context)?.close();
                    onTap();
                  },
            child: Container(
              width: 50.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: isGrised == true ? Style.grey100 : buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: Style.interRegular(
                      size: 15,
                      color: isGrised == true
                          ? Style.selectedItemsText
                          : Style.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

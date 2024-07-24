import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class DrawerPageHearderComponent extends StatelessWidget {
  const DrawerPageHearderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppHelpersCommon.getUserInLocalStorage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Style.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  '🧔🏽‍',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "${user?.lastname ?? ""} ${user?.firstname ?? ''}",
            style: Style.interBold(color: Style.white, size: 15),
          ),
        ),
       /* Text(
          user?.role?.name ?? '',
          style: Style.interNormal(color: Style.white, size: 12),
        ),*/
      ],
    );
  }
}

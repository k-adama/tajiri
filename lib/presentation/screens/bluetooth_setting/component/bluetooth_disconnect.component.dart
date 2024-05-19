import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/bluetooth_button.component.dart';

class BluetoothDisconectComponent extends StatelessWidget {
  final VoidCallback? onTap;
  const BluetoothDisconectComponent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bluetooth",
                    style: Style.interBold(size: 17),
                  ),
                  const Text(
                    "Déconnecter tous les périphériques",
                    style: TextStyle(color: Style.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const BluetoothButtonComponent(asset: "assets/svgs/blue_logo.svg")
          ],
        ),
      ),
    );
  }
}

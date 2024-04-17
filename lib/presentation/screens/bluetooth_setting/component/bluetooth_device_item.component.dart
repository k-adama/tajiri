import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class BluetoothDeviceItemComponent extends StatelessWidget {
  final bool isConnected;
  final String name;
  final VoidCallback onTap;
  const BluetoothDeviceItemComponent(
      {super.key,
      required this.isConnected,
      required this.name,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        // decoration: BoxDecoration(
        //   color: Style.white,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: Style.interNormal(size: 17),
              ),
            ),
            const SizedBox(width: 10),
            StatusConnectCard(
              isConnect: isConnected,
            ),
          ],
        ),
      ),
    );
  }
}

class StatusConnectCard extends StatelessWidget {
  final bool isConnect;
  const StatusConnectCard({super.key, required this.isConnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: isConnect ? const Color(0xffE0FBDB) : Style.lightBlueT,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isConnect ? "Connecté" : "Déconnecté",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isConnect ? Style.green : null,
        ),
      ),
    );
  }
}

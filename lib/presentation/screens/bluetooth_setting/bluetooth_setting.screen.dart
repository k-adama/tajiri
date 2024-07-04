import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/bluetooth_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/bluetooth_device_item.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/bluetooth_disconnect.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/dialog_paper_size.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/header_bluetooth.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class BluetoothSettingScreen extends StatefulWidget {
  const BluetoothSettingScreen({super.key});

  @override
  State<BluetoothSettingScreen> createState() => _BluetoothSettingScreenState();
}

class _BluetoothSettingScreenState extends State<BluetoothSettingScreen> {
  final bluetoothController =
      Get.find<NavigationController>().bluetoothController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.lightBlueT,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BluetoothHeaderComponent(
                      title: "Réglages bluetooth",
                      style: Style.interBold(size: 30.sp),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        children: [
                          BluetoothDisconectComponent(
                            onTap: () {
                              bluetoothController.disconnect();
                            },
                          ),
                          40.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Périphériques bluetooth",
                                  style: Style.interBold(size: 17),
                                ),
                              ),
                              const SizedBox(width: 10),
                              BluetoothButtonComponent(
                                asset: "assets/svgs/reload_blue.svg",
                                onTap: () {
                                  bluetoothController.getBluetoothDevices();
                                },
                              )
                            ],
                          ),
                          16.verticalSpace,
                          bluetoothController.progress.value
                              ? const CircularProgressIndicator.adaptive()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Style.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: bluetoothController.items.value
                                        .map((e) {
                                      return BluetoothDeviceItemComponent(
                                        isConnected: e.macAdress ==
                                            bluetoothController
                                                .macConnected.value,
                                        name: e.name,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return DialogPaperSizeComponent(
                                                  connectPrinter: () {
                                                    bluetoothController.connect(
                                                        e.macAdress, e.name);
                                                  },
                                                );
                                              });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: CustomButton(
                title: 'Imprimer un test',
                textColor: Style.white,
                weight: 20,
                background: bluetoothController.connected.value
                    ? Style.secondaryColor
                    : Style.bgGrey,
                radius: 3,
                isLoading: false,
                onPressed: bluetoothController.connected.value
                    ? () async {
                        await bluetoothController.printDemo();
                      }
                    : null,
              ),
            )
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/splash/splash.controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController splashController = Get.find();
  /* BluetoothDevice? _device;
  List<BluetoothDevice> _devices = [];
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      splashController.getToken();
    });
    return Image.asset(
      "assets/images/splash_edit.png",
      fit: BoxFit.fill,
    );
  }
}

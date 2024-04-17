import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/splash/splash.controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController splashController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      splashController.getToken();
    });
    return Image.asset(
      "assets/images/splash_edit.png",
      fit: BoxFit.fill,
    );
  }
}

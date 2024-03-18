import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/demo/components/swiper.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/demo/components/try_demo_or_not_component.dart';
class DemoAppScreen extends StatefulWidget {
  const DemoAppScreen({super.key});

  @override
  State<DemoAppScreen> createState() => _DemoAppScreenState();
}

class _DemoAppScreenState extends State<DemoAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwiperComponent(),
            TryDemoOrNotComponent()
          ],
        ),
      ),
    );
  }
}

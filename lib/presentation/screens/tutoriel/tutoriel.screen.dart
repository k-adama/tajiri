import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/tutoriel_list.component.dart';

class TutorielScreen extends StatefulWidget {
  const TutorielScreen({super.key});

  @override
  State<TutorielScreen> createState() => _TutorielScreenState();
}

class _TutorielScreenState extends State<TutorielScreen> {
  final PosController posController = Get.find();
  final NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const TutorielListComponent(),
    );
  }
}

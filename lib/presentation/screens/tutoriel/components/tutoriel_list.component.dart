import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/tutoriel/tutoriel.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/play_video.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/tutoriel_image.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/tutoriel_read_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/tutoriel_text.component.dart';

class TutorielListComponent extends StatefulWidget {
  const TutorielListComponent({super.key});

  @override
  State<TutorielListComponent> createState() => _TutorielListComponentState();
}

class _TutorielListComponentState extends State<TutorielListComponent> {
  final TutorielsController tutorielController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TutorielTextComponent(
            title: "Vidéos tutoriels",
            description:
                "Découvrez les fonctionnalités de l'application Tajiri à travers nos vidéos tutoriels.",
          ),
          10.verticalSpace,
          Obx(() {
            if (tutorielController.tutoriels.isNotEmpty) {
              return Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: tutorielController.tutoriels.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tuto = tutorielController.tutoriels[index];
                      return InkWell(
                        onTap: () {
                          Mixpanel.instance.track("View Single Tutoriel",
                              properties: {
                                "Date": DateTime.now().toString(),
                                "name": tuto.description!
                              });

                          AppHelpersCommon.showAlertVideoDemoDialog(
                            context: context,
                            child: PlayVideoComponent(
                              videoUrl: tuto.videoUrl!,
                            ),
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Stack(
                              children: [
                                TutorielImageComponent(
                                  height: (screenSize.height / 2) - 200.h,
                                  imageUrl: tuto.minatureUrl!,
                                ),
                                TutorielReadButton(
                                  bottom: 10,
                                  right: 30,
                                  containerWidth: (screenSize.width / 2) - 100,
                                  containerHeight:
                                      (screenSize.height / 2) - 360,
                                  svgAsset: "assets/svgs/gridicons_play.svg",
                                  buttonText: "Lire",
                                ),
                              ],
                            )),
                      );
                    }),
              );
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }
}

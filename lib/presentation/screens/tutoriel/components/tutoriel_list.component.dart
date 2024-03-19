import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/tutoriel/tutoriel.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/components/play_video.component.dart';

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
          Text(
            "Vidéos tutoriels",
            style: Style.interBold(size: 23.sp),
          ),
          5.verticalSpace,
          Text(
            "Découvrez les fonctionnalités de l'application Tajiri à travers nos vidéos tutoriels.",
            style: Style.interNormal(color: Style.dark),
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
                                Container(
                                  width: double.infinity,
                                  height: (screenSize.height / 2) - 200.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Style.secondaryColor,
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(tuto.minatureUrl!),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  right: 30.w,
                                  child: Container(
                                    width: (screenSize.width / 2) - 100.w,
                                    height: (screenSize.height / 2) - 360.h,
                                    decoration: BoxDecoration(
                                        color: Style.darker.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Lire",
                                            style: Style.interBold(
                                              color: Style.white,
                                              isUnderLine: true,
                                              underLineColor: Style.white,
                                            ),
                                          ),
                                          Container(
                                            width:
                                                (screenSize.width / 2) - 150.w,
                                            height:
                                                (screenSize.height / 2) - 10.h,
                                            child: SvgPicture.asset(
                                                "assets/svgs/gridicons_play.svg"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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

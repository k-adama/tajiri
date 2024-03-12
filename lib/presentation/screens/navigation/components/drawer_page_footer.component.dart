import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class DrawerPageFooterComponent extends StatelessWidget {
  const DrawerPageFooterComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 350.0),
      child: SizedBox(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const Divider(
                color: Style.light,
              ),
              /*  ListTile(
                title: InkWell(
                  onTap: () {
                    //Get.toNamed(Routes.INVITE_FRIEND);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.link,
                        color: Style.light,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Inviter un ami',
                        style:
                            Style.interBold(size: 15.sp, color: Style.darker),
                      )
                    ],
                  ),
                ),
              ), */
              ListTile(
                title: InkWell(
                  onTap: () {
                    // AppHelpersCommon.logoutApi();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Style.light,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Se déconnecter",
                        style:
                            Style.interBold(size: 15.sp, color: Style.darker),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

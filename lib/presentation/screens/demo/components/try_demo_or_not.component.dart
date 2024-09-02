import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/demo/components/create_or_have_account.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class TryDemoOrNotComponent extends StatelessWidget {
  const TryDemoOrNotComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        children: [
          CustomButton(
              title: "Démo gratuite",
              background: Style.primaryColor,
              textColor: Style.secondaryColor,
              isLoadingColor: Style.secondaryColor,
              radius: 3,
              onPressed: () {
                Get.toNamed(Routes.DEMO_LOGIN);
              }),
          10.verticalSpace,
          const SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreateOrHaveAccountComponent(
                    title: "J'ai déjà un compte",
                    path: Routes.LOGIN,
                    style: Style.secondaryColor),
                SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

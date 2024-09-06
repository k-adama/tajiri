import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';

TajiriDesignSystem tajiriDesignSystem = TajiriDesignSystem.instance;

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Style.secondaryColor),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                50.verticalSpace,
                GradientText(
                  "Sélectionnez\nvotre rôle",
                  textAlign: TextAlign.center,
                  style: Style.interBold(
                    size: 36,
                  ),
                  gradient: const LinearGradient(
                    colors: Style.surfaceBlueGradiant,
                  ),
                ),
                10.verticalSpace,
                Text(
                  "Vous êtes ?",
                  style: Style.interRegular(
                    color: tajiriDesignSystem.appColors.mainGrey500,
                    size: 20,
                  ),
                ),
                10.verticalSpace,
                const Text("Un restaurant, un maquis, un bar ou un dépôt"),
                100.verticalSpace,
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const Expanded(
                        child: ChooseRoleItem(
                          asset: "assets/svgs/choose_role_client.svg",
                          title: "Client",
                          description: "Restaurant, Bar, Maquis ...",
                        ),
                      ),
                      17.horizontalSpace,
                      Expanded(
                        child: ChooseRoleItem(
                          asset: "assets/svgs/choose_role_fournisseur.svg",
                          title: "Client",
                          description: "Dépôt, grossiste ...",
                          onTap: () {
                            Get.offAllNamed(Routes.DEPOSIT_NAVIGATION);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseRoleItem extends StatelessWidget {
  final String asset;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ChooseRoleItem(
      {super.key,
      required this.asset,
      required this.title,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Style.white,
          border: Border.all(color: Style.grey100),
          borderRadius: tajiriDesignSystem.appBorderRadius.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(asset),
            8.verticalSpace,
            Text(
              title,
              style: Style.interBold(),
            ),
            8.verticalSpace,
            Text(
              description,
              style: TextStyle(
                color: tajiriDesignSystem.appColors.mainGrey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, textAlign: textAlign, style: style),
    );
  }
}

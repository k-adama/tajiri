import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/auth/auth.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_svg/svg.dart';

class DemoLoginView extends StatefulWidget {
  const DemoLoginView({
    super.key,
  });

  @override
  State<DemoLoginView> createState() => _DemoLoginViewState();
}

class _DemoLoginViewState extends State<DemoLoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) => UpgradeAlert(
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Style.primaryColor,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/background_pattern.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            50.verticalSpace,
                            SvgPicture.asset("assets/svgs/logo_tajiri.svg",
                                height: 200),
                            RichText(
                              text: TextSpan(
                                text: "Découvrez Tajiri",
                                style: Style.interNormal(
                                    size: 27, color: Style.secondaryColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "",
                                      style: Style.interNormal(
                                          size: 30,
                                          color: Style.secondaryColor)),
                                ],
                              ),
                            ),
                            30.verticalSpace,
                            SizedBox(
                              width: 320.w,
                              child: Text(
                                TrKeysConstant.demoWelcomeText,
                                textAlign: TextAlign.center,
                                style: Style.interNormal(
                                    size: 15, color: Style.secondaryColor),
                              ),
                            ),
                            40.verticalSpace,
                            OutlinedBorderTextFormField(
                                labelText: "Votre nom",
                                onChanged: authController.setName,
                                isError: authController.isNameNotValid,
                                descriptionText: authController.isNameNotValid
                                    ? "Entrer votre nom"
                                    : null,
                                //hint: "Numéro de téléphone",
                                haveBorder: true,
                                isFillColor: true,
                                borderRaduis: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                hintColor: Style.dark),
                            1.verticalSpace,
                            OutlinedBorderTextFormField(
                                labelText: "Votre numéro de téléphone",
                                onChanged: authController.setEmail,
                                isError: authController.isEmailNotValid,
                                descriptionText: authController.isEmailNotValid
                                    ? "Entrer votre contact"
                                    : null,
                                //hint: "Numéro de téléphone",
                                haveBorder: true,
                                isFillColor: true,
                                borderRaduis: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                hintColor: Style.dark),
                            150.verticalSpace,
                            CustomButton(
                              isLoading: authController.isLoading,
                              background: Style.white,
                              textColor: Style.secondaryColor,
                              isLoadingColor: Style.secondaryColor,
                              title: 'Tester',
                              radius: 5,
                              onPressed: () {
                                authController.demoAuth(context);
                              },
                            ),
                            100.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

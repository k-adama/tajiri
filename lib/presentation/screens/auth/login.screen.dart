import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/auth/auth.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/text/forgot_button.text.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:upgrader/upgrader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                                height: 200.h),
                            RichText(
                              text: TextSpan(
                                text:TrKeys.welcomeText ,
                                style: Style.interNormal(
                                    size: 27.sp, color: Style.secondaryColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " !",
                                      style: Style.interNormal(
                                          size: 30.sp,
                                          color: Style.secondaryColor)),
                                ],
                              ),
                            ),
                            30.verticalSpace,
                            Container(
                              width: 320.w,
                              child: Text(
                                TrKeys.descriptionAppText,
                                textAlign: TextAlign.center,
                                style: Style.interNormal(
                                    size: 15.sp, color: Style.secondaryColor),
                              ),
                            ),
                            40.verticalSpace,
                            OutlinedBorderTextFormField(
                                labelText: "Numéro de téléphone",
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
                            1.verticalSpace,
                            OutlinedBorderTextFormField(
                              labelText: "Mot de passe",
                              obscure: authController.showPassword,
                              //hint: "Mot de passe",
                              hintColor: Style.dark,
                              haveBorder: true,
                              isFillColor: true,
                              borderRaduis: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                splashRadius: 25,
                                padding: const EdgeInsets.only(right: 13),
                                icon: authController.password.isNotEmpty
                                    ? SvgPicture.asset(
                                        authController.showPassword
                                            ? '${TrKeys.svgPath}fluent_eye-24-regular.svg'
                                            : '${TrKeys.svgPath}tabler_eye-closed.svg',
                                        height: 20.h,
                                      )
                                    : Container(),
                                onPressed: () => authController.setShowPassword(
                                    !authController.showPassword),
                              ),
                              onChanged: authController.setPassword,
                              isError: authController.isPasswordNotValid,
                              descriptionText: authController.isPasswordNotValid
                                  ? "Votre mot de passe doit contenir 8 caractères"
                                  : null,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                ForgotTextButton(
                                  title: "Mot de passe oublié",
                                  fontColor: Style.titleDark,
                                  onPressed: () {},
                                ),
                              ],
                            ),

                            100.verticalSpace,
                            CustomButton(
                              isLoading: authController.isLoading,
                              background: Style.white,
                              textColor: Style.secondaryColor,
                              isLoadingColor: Style.secondaryColor,
                              title: 'Connexion',
                              radius: 5,
                              onPressed: () {
                                authController.login(context);
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
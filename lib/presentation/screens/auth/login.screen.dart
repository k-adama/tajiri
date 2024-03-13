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
import 'package:tajiri_pos_mobile/presentation/screens/auth/widgets/login_welcome.widget.dart';
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
                            LoginWelcomeWidget(),
                            OutlinedBorderTextFormField(
                                labelText: TrKeysConstant.phoneOrEmailLabelText,
                                onChanged: authController.setEmail,
                                isError: authController.isEmailNotValid,
                                descriptionText: authController.isEmailNotValid
                                    ? TrKeysConstant.phoneOrEmailDescriptionText
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
                              labelText: TrKeysConstant.passwordLabelText,
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
                                            ? '${TrKeysConstant.svgPath}fluent_eye-24-regular.svg'
                                            : '${TrKeysConstant.svgPath}tabler_eye-closed.svg',
                                        height: 20.h,
                                      )
                                    : Container(),
                                onPressed: () => authController.setShowPassword(
                                    !authController.showPassword),
                              ),
                              onChanged: authController.setPassword,
                              isError: authController.isPasswordNotValid,
                              descriptionText: authController.isPasswordNotValid
                                  ? TrKeysConstant.passwordDescriptionText
                                  : null,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                ForgotTextButton(
                                  title: TrKeysConstant.forgetPasswordText,
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
                              title: TrKeysConstant.connexionButtonLoginText,
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
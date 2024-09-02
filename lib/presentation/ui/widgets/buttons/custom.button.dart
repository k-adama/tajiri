import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

class CustomButton extends StatelessWidget {
  final Icon? icon;
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final Color? isLoadingColor;
  final double weight;
  final double? height;
  final double radius;
  final String imagePath;
  final bool isUnderline;
  final Color underLineColor;
  final bool haveBorder;
  final bool isGrised;

  const CustomButton({
    super.key,
    this.isGrised = false,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 40,
    this.imagePath = "",
    this.haveBorder = false,
    this.isUnderline = false,
    this.underLineColor = Style.secondaryColor,
    this.background = Style.primaryColor,
    this.textColor = Style.white,
    this.isLoadingColor = Style.white,
    this.weight = double.infinity,
    this.radius = 8,
    this.icon,
    this.borderColor = Style.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, height!),
          side: BorderSide(
              color: isGrised == true
                  ? Style.grey100
                  : borderColor, //Style.primaryColor,
              width: haveBorder ? 2.r : 1.r),
          elevation: 0,
          shadowColor: Style.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.r),
          ),
          backgroundColor: isGrised == true ? Style.grey100 : background,
        ),
        onPressed: isGrised == true
            ? null
            : isLoading
                ? () {
                    print("========Chargement en cours========");
                    AppHelpersCommon.showCheckTopSnackBarInfo(
                      context,
                      displayDuration: const Duration(seconds: 1),
                      "Veuillez patienter Chargement en cours...",
                    );
                  }
                : onPressed,
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      color: isLoadingColor,
                      strokeWidth: 2.r,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Row(
                      children: [
                        icon!,
                        10.horizontalSpace,
                      ],
                    ),
                  Text(
                    title,
                    style: Style.interNormal(
                      size: 15,
                      color: isGrised == true
                          ? Style.selectedItemsText
                          : textColor,
                      underLineColor: underLineColor,
                      isUnderLine: isUnderline,
                      letterSpacing: -14 * 0.01,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                  if (imagePath.isNotEmpty) 10.horizontalSpace,
                  if (imagePath.isNotEmpty) SvgPicture.asset(imagePath)
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SuccessfullSecondDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? button;
  final String? asset;

  final Function()? closePressed, redirect;

  const SuccessfullSecondDialog({
    super.key,
    this.title = '',
    this.content,
    this.redirect,
    this.closePressed,
    this.button,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final isRedirect = redirect != null;
    if (isRedirect) {
      Future.delayed(const Duration(seconds: 2), () {
        redirect?.call();
      });
    }
    return Container(
      // width: 355.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (closePressed != null)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: closePressed,
                icon: const Icon(Icons.close),
              ),
            ),
          if (asset != null)
            SvgPicture.asset(
              asset!,
              width: 80,
              height: 80,
            ),
          if (asset != null) 10.verticalSpace,
          Center(
            child: Text(
              title,
              style: Style.interBold(size: 18),
            ),
          ),
          16.verticalSpace,
          SizedBox(
            width: 250,
            child: Text(
              content!,
              textAlign: TextAlign.center,
              style: Style.interNormal(size: 13, color: Color(0xff777986)),
            ),
          ),
          if (button != null) 20.verticalSpace,
          if (button != null) button!,
        ],
      ),
    );
  }
}

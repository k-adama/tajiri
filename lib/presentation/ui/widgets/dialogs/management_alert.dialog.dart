import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class ManagementDialog extends StatelessWidget {
  final String? title, content;
  final Widget? button;
  final String? asset;

  final Function()? closePressed, redirect;

  const ManagementDialog({
    super.key,
    this.title,
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
    return Stack(
      children: [
        Container(
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              46.verticalSpace,
              if (asset != null)
                Image.asset(
                  asset!,
                  width: 80,
                  height: 80,
                ),
              if (asset != null) 20.verticalSpace,
              Center(
                child: Text(
                  title!,
                  style: Style.interBold(),
                ),
              ),
              20.verticalSpace,
              SizedBox(
                width: 250,
                child: Text(
                  content!,
                  textAlign: TextAlign.center,
                  style: Style.interNormal(size: 12),
                ),
              ),
              if (button != null) 20.verticalSpace,
              if (button != null) button!,
            ],
          ),
        ),
        if (closePressed != null)
          Positioned(
            top: -15,
            right: -15,
            child: IconButton(
              onPressed: closePressed,
              icon: Icon(
                Icons.close,
                size: 26,
                color: Style.black,
              ),
            ),
          ),
      ],
    );
  }
}

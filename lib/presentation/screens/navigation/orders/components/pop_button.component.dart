import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/effects/bouncing_button.effect.dart';

class PopButtonComponent extends StatelessWidget {
  final String heroTag;

  const PopButtonComponent({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return BouncingButtonEffect(
      child: Hero(
        tag: heroTag,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: Style.black,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              FlutterRemix.arrow_right_s_line,
              color: Style.white,
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/blur_wrap.widget.dart';

class WrapModal extends StatelessWidget {
  final Widget body;

  const WrapModal({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurWrapWidget(
      radius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          color: Style.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Style.black.withOpacity(0.25),
              offset: const Offset(0, -2),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: body,
      ),
    );
  }
}

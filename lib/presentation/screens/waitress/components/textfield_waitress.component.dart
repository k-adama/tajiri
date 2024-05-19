import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class TextFieldWaitressComponent extends StatelessWidget {
  final String label;
  final String? optionalLabel;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;

  const TextFieldWaitressComponent({
    super.key,
    required this.label,
    this.optionalLabel,
    this.hint,
    this.initialValue,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          "$label ${optionalLabel != null ? '($optionalLabel)' : ''}",
          style: Style.interBold(size: 16.sp),
        ),
        4.verticalSpace,
        OutlinedBorderTextFormField(
          textController: controller,
          labelText: hint,
          onTap: () {},
          label: "",
          obscure: true,
          isFillColor: true,
          fillColor: Style.lightBlueT,
          differBorderColor: Style.lightBlueT,
          hintColor: Style.black,
          haveBorder: true,
          isInterNormal: false,
          borderRaduis: BorderRadius.circular(10),
          isCenterText: false,
        ),
      ],
    );
  }
}

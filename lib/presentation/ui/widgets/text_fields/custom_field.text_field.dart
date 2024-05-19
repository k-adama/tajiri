import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? optionalLabel;
  final String? hint;
  final String? value;
  final TextEditingController? controller;
  final Function(String text)? onChange;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    this.optionalLabel,
    this.hint,
    this.value,
    this.onChange,
    required this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$label ${optionalLabel != null ? '($optionalLabel)' : ''}",
          style: Style.interBold(size: 16.sp),
        ),
        const SizedBox(height: 4),
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
          onChanged: onChange,
          inputType: keyboardType,
          initialText: value,
        ),
      ],
    );
  }
}

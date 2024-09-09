import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class BorderTextField extends StatelessWidget {
  final String hintText;
  final double? width;
  final bool? isDescription;

  final double? height;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final FocusNode? searchFocusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  const BorderTextField(
      {super.key,
      required this.hintText,
      this.searchFocusNode,
      this.width,
      required this.controller,
      this.onChanged,
      this.height,
      this.backgroundColor,
      this.prefixIcon,
      this.keyboardType,
      this.isDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints:
          isDescription == true ? const BoxConstraints(minHeight: 78) : null,
      decoration: BoxDecoration(
        color: backgroundColor ?? Style.grey100,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: Style.grey100,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        maxLines: isDescription == true ? null : 1,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        focusNode: searchFocusNode,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Style.black,
        style: Style.interNormal(),
        enableSuggestions: false,
        decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: prefixIcon,
            prefixIconConstraints: BoxConstraints(maxWidth: 40)),
      ),
    );
  }
}

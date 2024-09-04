import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;

  final FocusNode? searchFocusNode;
  final TextEditingController? searchController;
  final Function(String)? searchOnChanged;
  const SearchTextField(
      {super.key,
      required this.hintText,
      this.searchFocusNode,
      this.width,
      required this.searchController,
      this.searchOnChanged,
      this.height,
      this.backgroundColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Style.grey100,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: borderColor ?? Style.grey100,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: TextFormField(
          controller: searchController,
          onChanged: searchOnChanged,
          focusNode: searchFocusNode,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Style.black,
          style: Style.interNormal(),
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            prefixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                "assets/svgs/search_svg.svg",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

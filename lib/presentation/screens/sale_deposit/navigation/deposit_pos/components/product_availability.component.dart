import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class CustomChooseYesOrNotComponent extends StatefulWidget {
  final String text;
  final Function() onTap;
  final bool isSelected;
  final bool borderBlack;

  const CustomChooseYesOrNotComponent({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
    this.borderBlack = true,
  });

  @override
  State<CustomChooseYesOrNotComponent> createState() =>
      _CustomChooseYesOrNotComponentState();
}

class _CustomChooseYesOrNotComponentState
    extends State<CustomChooseYesOrNotComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 113,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? tajiriDesignSystem.appColors.mainLightBlue50
              : Style.white,
          border: Border.all(
            color: widget.isSelected
                ? tajiriDesignSystem.appColors.mainLightBlue200
                : Style.grey100,
            width: 1.0.w,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: widget.isSelected
                  ? Style.interBold(size: 16)
                  : Style.interNormal(),
            )),
      ),
    );
  }
}

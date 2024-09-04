import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CategorieItemButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isSelect;
  final Color? cardSelectedColor;

  final String? asset;
  final String? description;

  const CategorieItemButton(
      {super.key,
      this.onTap,
      this.isSelect,
      this.asset,
      this.description,
      this.cardSelectedColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 4.w, right: 2.w, bottom: 10),
        child: SizedBox(
          height: 90.h,
          width: 90.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //here
              Container(
                height: 45.h,
                width: 45.w,
                decoration: BoxDecoration(
                  color: cardSelectedColor != null
                      ? isSelect == true
                          ? cardSelectedColor
                          : Style.lightBlue
                      : Style.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(asset ?? "", style: Style.interSemi(size: 20)),
                ),
              ),

              5.verticalSpace,
              Padding(
                padding:
                    const EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
                child: Center(
                  child: Text(description ?? "",
                      style: Style.interNormal(
                          size: 13,
                          color: isSelect == true
                              ? Style.secondaryColor
                              : Style.dark),
                      overflow: TextOverflow
                          .ellipsis, // Truncate the text with an ellipsis (...) when it overflows
                      maxLines: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

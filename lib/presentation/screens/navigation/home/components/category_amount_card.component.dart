import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/domain/entities/categorie_amount.entity.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';

class CategorieAmountCardComponent extends StatelessWidget {
  final CategoryAmountEntity categoryAmountEntity;
  const CategorieAmountCardComponent(
      {super.key, required this.categoryAmountEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 50.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Style.lightBlue),
              child: Center(
                child: Text(categoryAmountEntity.icon,
                    style: Style.interNormal(
                        size: 15.sp, color: Style.secondaryColor)),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Text(
                    categoryAmountEntity.name,
                    style: Style.interBold(
                      size: 10.sp,
                      color: Style.dark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "${categoryAmountEntity.total}".notCurrency(),
                    style: Style.interBold(size: 10.sp, color: Style.darker),
                    children: const <TextSpan>[
                      TextSpan(
                          text: TrKeysConstant.splashFcfa,
                          style: TextStyle(color: Style.dark)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

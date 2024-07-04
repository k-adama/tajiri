import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/paper_entity.dart';

class PaperCardComponent extends StatelessWidget {
  final PaperEntity paper;
  final bool isSelect;
  final VoidCallback onPressed;
  const PaperCardComponent(
      {super.key,
      required this.paper,
      required this.onPressed,
      required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.5, color: isSelect ? Style.black : Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              paper.asset,
              color: isSelect ? Style.black : null,
            ),
            5.verticalSpace,
            Text(
              paper.title,
              style: Style.interNormal(
                size: 14,
                color: isSelect ? Style.black : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class AddGroudButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddGroudButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: tajiriDesignSystem.appBorderRadius.sm,
          border: Border.all(color: Style.black, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(
                    Icons.add,
                    color: Style.white,
                  ),
                ),
              ),
            ),
            11.horizontalSpace,
            Flexible(
              child: Text(
                "Créer un goupe",
                style: Style.interBold(size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

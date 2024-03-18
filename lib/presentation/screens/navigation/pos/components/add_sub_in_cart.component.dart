import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/components/update_count_product_button.component.dart';

class AddSubInCartComponent extends StatelessWidget {
  final String text;
  final VoidCallback addCount;
  final VoidCallback removeCount;

  const AddSubInCartComponent({
    super.key,
    required this.text,
    required this.addCount,
    required this.removeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              color: Style.white,
              border: Border.all(color: Style.white, width: 4)),
          child: Row(
            children: [
              UpdateCountProductButton(
                iconData: Icons.remove,
                onTap: removeCount,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Text(
                  text,
                  style: Style.interBold(
                    size: 14,
                    color: Style.black,
                  ),
                ),
              ),
              UpdateCountProductButton(
                iconData: Icons.add,
                onTap: addCount,
              ),
            ],
          ),
        ),
        const Spacer(),
        Container()
      ],
    );
  }
}

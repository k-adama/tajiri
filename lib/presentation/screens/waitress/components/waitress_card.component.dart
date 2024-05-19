import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/waitress.entity.dart';

class WaitressCardComponent extends StatelessWidget {
  final WaitressEntity waitress;
  final Function(String)? onSelectedPopupMenuButton;
  const WaitressCardComponent(
      {super.key,
      required this.waitress,
      required this.onSelectedPopupMenuButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: <Widget>[
          waitress.gender != null && waitress.gender == 'MALE'
              ? SvgPicture.asset('assets/svgs/noto_man.svg')
              : SvgPicture.asset('assets/svgs/noto_woman.svg'),
          SizedBox(width: 8.0.w),
          Expanded(
            child: Text(waitress.name ?? "",
                style: Style.interBold(
                  size: 15,
                )),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svgs/edit_waitress.svg'),
                      8.horizontalSpace,
                      const Text('Modifier'),
                    ],
                  )),
              PopupMenuDivider(
                height: 10.h,
              ),
              PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svgs/delete_waitress.svg'),
                      8.horizontalSpace,
                      const Text('Supprimer'),
                    ],
                  )),
            ],
            onSelected: onSelectedPopupMenuButton,
          ),
        ],
      ),
    );
  }
}

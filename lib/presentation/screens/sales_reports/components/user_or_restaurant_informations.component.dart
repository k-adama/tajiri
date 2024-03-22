import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class UserOrRestaurantInformationComponent extends StatelessWidget {
  final String restaurantName;
  final String contactPhone;
  final String userName;
  const UserOrRestaurantInformationComponent({
    Key? key,
    required this.restaurantName,
    required this.contactPhone,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantName,
                style: Style.interBold(size: 30.sp, color: Style.black),
              ),
              10.verticalSpace,
              Row(
                children: [
                  userInformation(
                    "${TrKeysConstant.svgPath}ic_round-phone.svg",
                    contactPhone,
                  ),
                  10.horizontalSpace,
                  userInformation(
                    "${TrKeysConstant.svgPath}Vector.svg",
                    userName,
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget userInformation(String svgPath, String content) {
    return Row(
      children: [
        SvgPicture.asset(svgPath),
        5.horizontalSpace,
        Text(
          content,
          style: Style.interNormal(size: 14, color: Style.black),
        ),
      ],
    );
  }
}

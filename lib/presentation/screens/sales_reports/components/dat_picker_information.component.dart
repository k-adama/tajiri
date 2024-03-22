import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SalesReportsDatePickerInformationComponent extends StatelessWidget {
  final String startDate;
  final String endDate;
  const SalesReportsDatePickerInformationComponent(
      {Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            informationWidget("De ", startDate),
            informationWidget("A ", endDate),
          ],
        ),
      ),
    );
  }

  Widget informationWidget(String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Style.interBold(
              size: 12,
            ),
          ),
          5.horizontalSpace,
          Container(
            decoration: BoxDecoration(
                color: Style.lightBlueT,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                body,
                style: Style.interNormal(
                  size: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

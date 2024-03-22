import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final List<DateTime?> range;
  final void Function(List<DateTime?> values) onValuesChanged;

  const CustomDatePickerWidget(
      {Key? key, required this.range, required this.onValuesChanged})
      : super(key: key);

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: Style.secondaryColor,
    weekdayLabelTextStyle: Style.interNormal(
      size: 14.sp,
      letterSpacing: -0.3,
      color: Style.black,
    ),
    controlsTextStyle: Style.interNormal(
      size: 14.sp,
      letterSpacing: -0.3,
      color: Style.black,
    ),
    dayTextStyle: Style.interNormal(
      size: 14.sp,
      letterSpacing: -0.3,
      color: Style.black,
    ),
    disabledDayTextStyle: Style.interNormal(
      size: 14.sp,
      letterSpacing: -0.3,
      color: Style.bgGrey,
    ),
    dayBorderRadius: BorderRadius.circular(10.r),
  );

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker2(
        config: config,
        value: widget.range,
        onValueChanged: (values) => widget.onValuesChanged(values));
  }
}

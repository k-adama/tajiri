import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/outline_bordered_pick_date.component.dart';

class SelectDateTimePickerComponent extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String labelText;
  final IconData iconData;
  final TextEditingController dateTimeController;
  final VoidCallback onTap;
  const SelectDateTimePickerComponent({
    super.key,
    required this.padding,
    required this.labelText,
    required this.iconData,
    required this.dateTimeController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: padding,
        height: MediaQuery.of(context).size.width / 5,
        child: OutlineBorderedPickDateAndTimeComponent(
          labelText: labelText,
          iconData: iconData,
          dateTimeController: dateTimeController,
          onTap: onTap,
        ),
      ),
    );
  }
}

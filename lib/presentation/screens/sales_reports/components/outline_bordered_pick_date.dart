import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class OutlineBorderedPickDateAndTimeComponent extends StatelessWidget {
  final TextEditingController? dateTimeController;
  final String? labelText;
  final VoidCallback? onTap;
  final IconData? iconData;
  const OutlineBorderedPickDateAndTimeComponent(
      {Key? key,
      required this.labelText,
      this.dateTimeController,
      this.onTap,
      this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: dateTimeController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Style.lightBlueT,
          prefixIcon: Icon(
            iconData,
            color: Style.titleDark,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 50,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          labelStyle: const TextStyle(
            color: Style.white,
            fontSize: 12,
            height: 0.4,
          ),
        ),
        readOnly: false,
        onTap: onTap,
      ),
    );
  }
}

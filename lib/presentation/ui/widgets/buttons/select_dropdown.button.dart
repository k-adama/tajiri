import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SelectDropDownButton<T> extends StatelessWidget {
  final Color containerColor;
  final T? value;
  final String hinText;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  const SelectDropDownButton({
    super.key,
    required this.containerColor,
    this.value,
    required this.onChanged,
    required this.hinText,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: containerColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          borderRadius: BorderRadius.circular(24),
          icon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: Style.black,
            ),
          ),
          items: items,
          hint: Container(
            margin: const EdgeInsets.symmetric(horizontal: 11),
            child: Text(hinText),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

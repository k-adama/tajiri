import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';

class SelectDropDownButton extends StatelessWidget {
  final Color containerColor;
  final TableModel? value;
  final String hinText;
  final List<TableModel> tableListData;
  final void Function(TableModel?)? onChanged;

  const SelectDropDownButton({
    super.key,
    required this.containerColor,
    this.value,
    required this.tableListData,
    required this.onChanged,
    required this.hinText,
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
        child: DropdownButton<TableModel>(
          value: value,
          borderRadius: BorderRadius.circular(24),
          icon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: Style.black,
            ),
          ),
          items: tableListData.map((TableModel item) {
            int index = tableListData.indexOf(item);
            return DropdownMenuItem<TableModel>(
              value: item,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Style.colors[index % Style.colors.length],
                ),
                child: Row(
                  children: [
                    10.horizontalSpace, // Assuming you have a horizontalSpace widget
                    4.horizontalSpace,
                    Text('${item.name}'),
                  ],
                ),
              ),
            );
          }).toList(),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';

class SelectTableWidget extends StatefulWidget {
  final Color containerColor;
  final TableModel? value;
  final List<TableModel> tableListData;
  final void Function(TableModel?)? onChanged;
  const SelectTableWidget(
      {super.key,
      required this.containerColor,
      this.value,
      required this.tableListData,
      required this.onChanged});

  @override
  State<SelectTableWidget> createState() => _SelectTableWidgetState();
}

class _SelectTableWidgetState extends State<SelectTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: widget.containerColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TableModel>(
          value: widget.value,
          borderRadius: BorderRadius.circular(24),
          icon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: Style.black,
            ),
          ),
          items: widget.tableListData.map((TableModel item) {
            int index = widget.tableListData.indexOf(item);
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
                    10.horizontalSpace,
                    4.horizontalSpace,
                    Text('${item.name}'),
                  ],
                ),
              ),
            );
          }).toList(),
          hint: Container(
            margin: const EdgeInsets.symmetric(horizontal: 11),
            child: const Text("Toutes les tables"),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

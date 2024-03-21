import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class NoteFieldComponent extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  const NoteFieldComponent(
      {super.key, required this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              maxLines: null,
              onChanged: onChanged,
              cursorColor: Style.titleDark,
              style: const TextStyle(
                color: Style.black,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

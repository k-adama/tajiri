import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';

class StockSearchBarComponent extends StatefulWidget {
  final bool checkboxstatus;
  const StockSearchBarComponent({super.key, required this.checkboxstatus});

  @override
  State<StockSearchBarComponent> createState() =>
      _StockSearchBarComponentState();
}

class _StockSearchBarComponentState extends State<StockSearchBarComponent> {
  final StockController stockController = Get.find<StockController>();
  final TextEditingController recherch = TextEditingController();
  bool isSearchFocused = false;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    recherch.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.white,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 55.0.h,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Style.lighter,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextField(
                  controller: recherch,
                  onChanged: (text) {
                    stockController.searchFilter(text, widget.checkboxstatus);
                  },
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    hintText:
                        isSearchFocused || recherch.text.isNotEmpty ? "" : "",
                    prefixIcon: isSearchFocused || recherch.text.isNotEmpty
                        ? null
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: Style.titleDark,
                                  size: 30,
                                ),
                                SizedBox(width: 10.0.sp),
                                Text("Rechercher un plat, une boisson ...",
                                    style: Style.interNormal(
                                        color: Style.dark, size: 14.sp)),
                              ],
                            ),
                          ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Style.secondaryColor,
                        width: 1.0.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';

class PosSearchComponent extends StatefulWidget {
  final PosController posController;
  const PosSearchComponent({super.key, required this.posController});

  @override
  State<PosSearchComponent> createState() => _PosSearchState();
}

class _PosSearchState extends State<PosSearchComponent> {
  final TextEditingController searchController = TextEditingController();
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
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.white,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 55.0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Style.lighter,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (text) {
                    widget.posController.searchFilter(text);
                  },
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    hintText:
                        isSearchFocused || searchController.text.isNotEmpty
                            ? ""
                            : "",
                    prefixIcon:
                        isSearchFocused || searchController.text.isNotEmpty
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
                                    const SizedBox(width: 10.0),
                                    Text("Rechercher un plat, une boisson ...",
                                        style: Style.interNormal(
                                            color: Style.dark, size: 14)),
                                  ],
                                ),
                              ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Style.secondaryColor,
                        width: 1.0,
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

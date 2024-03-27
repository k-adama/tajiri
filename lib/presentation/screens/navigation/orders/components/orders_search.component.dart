import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';

class OrdersSearchComponent extends StatefulWidget {
  const OrdersSearchComponent({super.key});

  @override
  State<OrdersSearchComponent> createState() => _OrdersSearchComponentState();
}

class _OrdersSearchComponentState extends State<OrdersSearchComponent> {
  final OrdersController ordersController = Get.find<OrdersController>();
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  controller: recherch,
                  onChanged: (text) {
                    ordersController.searchFilter(text);
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
                                const SizedBox(width: 10.0),
                                Text("Rechercher une commande ...",
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

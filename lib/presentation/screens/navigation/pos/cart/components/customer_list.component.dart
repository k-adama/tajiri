import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/add_customer_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/customer_info_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/components/search_customer.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';

class CustomerListComponent extends StatefulWidget {
  const CustomerListComponent({super.key});

  @override
  State<CustomerListComponent> createState() => _CustomerListComponentState();
}

class _CustomerListComponentState extends State<CustomerListComponent> {
  final posController = Get.find<PosController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() => SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Style.white,
                          spreadRadius: 0,
                          blurRadius: 40,
                          offset: Offset(0, -2),
                        ),
                      ],
                      color: Style.white.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      )),
                  width: double.infinity,
                  child: KeyboardDismisserUI(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        8.verticalSpace,
                        Center(
                          child: Container(
                            height: 4.0.h,
                            width: 48.0.w,
                            decoration: const BoxDecoration(
                              color: Style.dragElement,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20.0,
                                ), // Adjust radius as needed
                              ),
                            ),
                          ),
                        ),
                        24.verticalSpace,
                        SizedBox(
                          height: 70.h,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Liste client",
                                    style: Style.interBold(size: 18.sp),
                                  ),
                                  Text(
                                    "Liste des clients enregistrés",
                                    style: Style.interNormal(
                                        size: 13.sp, color: Style.dark),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  AppHelpersCommon.showCustomModalBottomSheet(
                                    context: context,
                                    modal: const AddCustomerModalComponent(),
                                    isDarkMode: false,
                                    isDrag: true,
                                    radius: 12,
                                  );
                                },
                                child: Container(
                                  width: 130.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          width: 1.5.w,
                                          color: Style.titleDark)),
                                  child: Center(
                                    child: Text(
                                      "Nouveau client",
                                      style: Style.interNormal(size: 13.sp),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        const SearchCustomerComponent(),
                        SizedBox(
                          height: 400.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: posController.customers.length,
                            itemBuilder: (BuildContext context, index) {
                              final customer = posController.customers[index];
                              return GestureDetector(
                                onTap: () {
                                  posController.customer.value = customer;
                                  Get.back();
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Style.dividerGrey
                                                .withOpacity(0.4),
                                            width: 1.w)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 300.w,
                                          child: DataCustomerInfoCard(
                                            customer: customer,
                                            width: (size.width - 50) * 0.60,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Style.dark,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                )),
          ),
        ));
  }
}

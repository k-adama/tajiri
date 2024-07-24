import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class SalesPayAndRegisterComponent extends StatefulWidget {
  final HomeController homeController;
  const SalesPayAndRegisterComponent({super.key, required this.homeController});

  @override
  State<SalesPayAndRegisterComponent> createState() =>
      _SalesPayAndRegisterComponentState();
}

class _SalesPayAndRegisterComponentState
    extends State<SalesPayAndRegisterComponent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 8.0.w),
      child: Container(
        width: size.width - 100.w, //(size.width - 110) / 2
        height: (size.height / 3) - 100.h,
        decoration: BoxDecoration(
          color: Style.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 50.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                        color: Style.yellowLigther,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: InkWell(
                      onTap: () {
                        print(widget.homeController.ordersPaid);
                      },
                      child: Text(
                        "Total",
                        style: Style.interNormal(size: 14.sp),
                      ),
                    )),
                  ),
                  SizedBox(
                    width: 200.w,
                    height: 50.h,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: SizedBox(
                            width: 250.w,
                            height: 30.h,
                            child: Obx(
                              () => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    "${widget.homeController.totalAmount.value}"
                                        .notCurrency(),
                                    style: Style.interBold(
                                      size: 20.sp,
                                      color: Style.secondaryColor,
                                    ),
                                  ),
                                  Positioned(
                                    left: widget.homeController.totalAmount
                                                .value !=
                                            0
                                        ? widget.homeController.getTextWidth(
                                            widget.homeController.totalAmount
                                                .value
                                                .toString(),
                                            Style.interNormal(
                                              size: 20.sp,
                                              color: Style.darker,
                                            ),
                                          )
                                        : widget.homeController.getTextWidth(
                                              widget.homeController.totalAmount
                                                  .value
                                                  .toString(),
                                              Style.interNormal(
                                                size: 20.sp,
                                                color: Style.darker,
                                              ),
                                            ) +
                                            10.h,
                                    top: 6.h,
                                    child: SizedBox(
                                      width: 40.w,
                                      height: 14.h,
                                      child: Text(
                                        TrKeysConstant.splashFcfa,
                                        style: Style.interNormal(
                                            size: 8.sp, color: Style.darker),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250.w,
                          height: 20.h,
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${widget.homeController.comparisonDate.value} ",
                                  style: Style.interNormal(
                                      size: 10.sp, color: Style.darker),
                                ),
                                const Text(" | "),
                                SizedBox(width: 5.w),
                                widget.homeController.checkPercentValue(widget
                                            .homeController
                                            .percentComparaison
                                            .value) ==
                                        2
                                    ? Image.asset(
                                        "assets/images/bxs_up-arrow 1.png",
                                        width: 10.w,
                                        height: 10.h,
                                      )
                                    : widget.homeController.checkPercentValue(
                                                widget
                                                    .homeController
                                                    .percentComparaison
                                                    .value) ==
                                            1
                                        ? Image.asset(
                                            "assets/images/bxs_down-arrow.png",
                                            width: 10.w,
                                            height: 10.h,
                                          )
                                        : Container(),
                                Text(
                                  "${widget.homeController.percentComparaison.value.isFinite ? widget.homeController.percentComparaison.value.floor().toString() : "0"}%",
                                  style: Style.interNormal(
                                    size: 10.sp,
                                    color: Style.dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        "Ventes",
                        style: Style.interBold(
                          size: 10.sp,
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Center(
                          child: Wrap(spacing: 10, children: [
                            Obx(() => cardPaymentWidget(
                                context,
                                "Payées",
                                widget.homeController.ordersPaid.value,
                                Style.titleDark)),
                            Obx(() => cardPaymentWidget(
                                context,
                                "Enregistrées",
                                widget.homeController.ordersSave.value,
                                Style.titleDark)),
                          ]),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container cardPaymentWidget(
      BuildContext context, String text, int amount, Color colorAmount) {
    var size = MediaQuery.of(context).size;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      width: (size.width - 90) / 2,
      height: deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Style.yellowLigther,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Style.interNormal(size: 10.sp, color: Style.darker),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 140.w,
                  height: 25.h,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Text(
                        "$amount".notCurrency(),
                        style: Style.interBold(size: 14.sp, color: colorAmount),
                      ),
                      Positioned(
                        left: amount.toString().length <= 6
                            ? widget.homeController.getTextWidth(
                                  amount.toString(),
                                  Style.interBold(
                                    size: 10.sp,
                                    color: Style.darker,
                                  ),
                                ) -
                                70
                            : widget.homeController.getTextWidth(
                                  amount.toString(),
                                  Style.interBold(
                                    size: 10.sp,
                                    color: Style.darker,
                                  ),
                                ) -
                                50,
                        top: 2,
                        child: SizedBox(
                          width: 40.w,
                          height: 12.h,
                          child: Text(
                            TrKeysConstant.splashFcfa,
                            style: Style.interNormal(
                                size: 10.sp, color: Style.darker),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

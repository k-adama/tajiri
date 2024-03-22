import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SalesPricesComponent extends StatelessWidget {
  final String total;
  final Widget component;
  const SalesPricesComponent({
    Key? key,
    required this.total,
    required this.component,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Card(
        elevation: 10,
        shadowColor: Style.lighter,
        child: Container(
          width: double.infinity,
          height: 65.h,
          decoration: BoxDecoration(
              color: Style.primaryColor,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                              color: Style.yellowLigther,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Center(
                                child: Text(
                              "TOTAL VENTE",
                              style: Style.interNormal(size: 14),
                            )),
                          ),
                        ),
                        Container(
                          width: 200.w,
                          height: (screenSize.height / 3) - 220.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 250.w,
                                height: (screenSize.height / 3) - 220.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      total,
                                      style: Style.interBold(
                                        size: 22.sp,
                                        color: Style.secondaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    component,
                                    /*Positioned(
                                      left: salesReportController.getTextWidth(
                                          salesReportController.total.value
                                              .toString(),
                                          Style.interNormal(
                                            size: 20.sp,
                                            color: Style.darker,
                                          )),
                                      top: 6,
                                      child: Container(
                                        width: 40.w,
                                        height: 14.h,
                                        child: Text(
                                          TrKeys.splashFcfa,
                                          style: Style.interNormal(
                                              size: 8.sp, color: Style.darker),
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/constants/user.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/domain/entities/user.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/last_stock_added.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/make_ajustment.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/see_history_or_save_button.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/see_stock_history.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

class StockProductModalComponent extends StatefulWidget {
  FoodDataEntity food;
  StockProductModalComponent({super.key, required this.food});

  @override
  State<StockProductModalComponent> createState() =>
      _StockProductModalComponentState();
}

class _StockProductModalComponentState
    extends State<StockProductModalComponent> {
  final StockController stockController = Get.find();
  late dynamic userEncoding;
  late UserEntity user;
  bool seeHistory = false;
  int ajustementStock = 0;
  int quantity = 0;
  int addValue = 0;

  @override
  void initState() {
    userEncoding = LocalStorageService.instance.get(UserConstant.keyUser);
    user = UserEntity.fromJson(jsonDecode(userEncoding));
    quantity = widget.food.quantity ?? 0;
    addValue = quantity + ajustementStock;

    super.initState();
  }

  void increment() {
    setState(() {
      ajustementStock++;
      addValue = quantity + ajustementStock;
    });
  }

  void decrement() {
    setState(() {
      ajustementStock--;
      addValue = quantity + ajustementStock;
    });
  }

  void changeValue(int newQty) {
    setState(() {
      ajustementStock = newQty;
    });
  }

  void haveSeeHistory() {
    setState(() {
      seeHistory = !seeHistory;
    });
  }

  final NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Style.white.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: const Offset(0, -2), // changes position of shadow
                  ),
                ],
                color: Style.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                )),
            width: double.infinity,
            height: size.height - 150.h,
            child: seeHistory
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16.r, bottom: 10.r),
                          child: Container(
                            height: 35,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.r, right: 16.r),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Historique",
                                    style: Style.interNormal(
                                      size: 20,
                                      color: Style.black,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/svgs/close_icon.svg",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SeeStockHistoryComponent(
                            seeHistory: seeHistory,
                            stockList:
                                stockController.getSortList(widget.food?.Stock))
                      ],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          CustomNetworkImageUi(
                            url: widget.food.imageUrl!,
                            height: 300.h,
                            width: double.infinity,
                            radius: 10.r,
                            isRaduisTopLef: true,
                          ),
                          Positioned(
                            top: 10.0,
                            left: 0.0,
                            right: 0.0,
                            child: Center(
                              child: Container(
                                height: 4.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                    color: Style.dragElement,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40.r))),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 15,
                              left: 10,
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Style.white,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      '${widget.food.price!}'.currencyLong(),
                                      style: Style.interNormal(size: 11),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      24.verticalSpace,
                      MakeAjustmentComponent(
                          food: widget.food,
                          increment: increment,
                          decrement: decrement,
                          addValue: addValue,
                          ajustementStock: ajustementStock),
                      LastStockAddedComponent(food: widget.food, size: size),
                      SeeStockOrSaveButtonComponent(
                        food: widget.food,
                        seeHistory: seeHistory,
                        addValue: addValue,
                        haveSeeHistory: haveSeeHistory,
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

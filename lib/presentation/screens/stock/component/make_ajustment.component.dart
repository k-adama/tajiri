import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class MakeAjustmentComponent extends StatefulWidget {
  final FoodDataEntity food;
  final VoidCallback decrement;
  final VoidCallback increment;
  int addValue;
  int ajustementStock;
  MakeAjustmentComponent({super.key, required this.food, required this.increment, required this.decrement, required this.addValue, required this.ajustementStock});

  @override
  State<MakeAjustmentComponent> createState() => _MakeAjustmentComponentState();
}

class _MakeAjustmentComponentState extends State<MakeAjustmentComponent> {

  @override
  Widget build(BuildContext context) {
    return Container(
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).padding.bottom + 24.h,
                            right: 16.w,
                            left: 16.w),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Faire un ajustement",
                              style: Style.interBold(),
                            ),
                            Text(
                              "Corriger le stock disponible",
                              style: Style.interNormal(color: Style.dark),
                            ),
                            24.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.r),
                                ),
                                border: Border.all(
                                  color: Style.white,
                                  width: 4,
                                ),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.decrement();
                                      });
                                    },
                                    child: AnimationButtonEffect(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Style.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "-",
                                            style: Style.interBold(
                                              size: 15,
                                              color: Style.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Style.dark,
                                              style: BorderStyle.solid,
                                              width: 1)),
                                      child: OutlinedBorderTextFormField(
                                        onTap: () {},
                                        label: "",
                                        obscure: true,
                                        inputType: TextInputType.number,
                                        hint: widget.addValue.toString(),
                                        isFillColor: false,
                                        hintColor: Style.black,
                                        onChanged: (change) {
                                          debugPrint(change);

                                          setState(() {
                                            widget.addValue = int.parse(change);
                                            widget.ajustementStock = 0;
                                          });
                                        },
                                        haveBorder: false,
                                        descriptionText: "",
                                        isCenterText: true,
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.increment();
                                      });
                                    },
                                    child: AnimationButtonEffect(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Style.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+",
                                            style: Style.interBold(
                                              size: 15,
                                              color: Style.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
  }
}
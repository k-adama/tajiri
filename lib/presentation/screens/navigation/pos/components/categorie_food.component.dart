import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';

class CategorieFoodComponent extends StatelessWidget {
  final PosController posController;
  const CategorieFoodComponent({super.key, required this.posController});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final categories = posController.categories;
    return Container(
      width: double.infinity,
      color: Style.white,
      height: (screenSize.height / 3) - 150.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
        child: GetBuilder<PosController>(builder: (_) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, index) {
                print(
                    "${categories[index].name}  ${categories[index].imageUrl}");
                return InkWell(
                  onTap: () {
                    posController.handleFilter(
                        categories[index].id, categories[index].name);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 4.w, right: 2.w, bottom: 10),
                    child: SizedBox(
                      height: 90.h,
                      width: 90.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //here
                          Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: const BoxDecoration(
                                color: Style.lightBlue, shape: BoxShape.circle),
                            child: Center(
                              child: Text(categories[index].imageUrl!,
                                  style: Style.interSemi(size: 20)),
                            ),
                          ),

                          5.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2, bottom: 2, right: 4, left: 4),
                            child: Center(
                              child: Text(categories[index].name!.toString(),
                                  style: Style.interNormal(
                                      size: 11,
                                      color: categories[index].id ==
                                              posController.categoryId.value
                                          ? Style.secondaryColor
                                          : Style.dark),
                                  overflow: TextOverflow
                                      .ellipsis, // Truncate the text with an ellipsis (...) when it overflows
                                  maxLines: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';

class Top10ProductsComponent extends StatefulWidget {
  final HomeController homeController;
  const Top10ProductsComponent({super.key, required this.homeController});

  @override
  State<Top10ProductsComponent> createState() => _Top10ProductsState();
}

class _Top10ProductsState extends State<Top10ProductsComponent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: widget.homeController.top10Foods.isEmpty
          ? 100.h
          : (size.height / 2) -
              200.h, //homeController.top10Foods.length == 1 ? homeController.top10Foods.length * 159.0 : homeController.top10Foods.length * 74,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.h,
              child: Text(
                "Top 10 des produits",
                style: Style.interBold(size: 18.sp, color: Style.titleDark),
              ),
            ),
            20.verticalSpace,
            Flexible(
              child: ListView.builder(
                //physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.homeController.top10Foods.length,
                itemBuilder: (BuildContext context, int index) {
                  var paymentItem = widget.homeController.top10Foods[index];

                  return productCard(paymentItem, index + 1, size);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(dynamic paymentItem, int index, dynamic size) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: (size.width - 110) / 2,
        height: (size.width - 90) / 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Style.green,
            image: DecorationImage(
                image: index == 1
                    ? const AssetImage("assets/images/first.png")
                    : const AssetImage("assets/images/second.png"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(index.toString(),
                        style:
                            Style.interBold(size: 25.sp, color: Style.white)),
                    index == 1
                        ? SvgPicture.asset("assets/svgs/badge.svg")
                        : Container(),
                  ],
                ),
                SizedBox(
                  width: 200.w,
                  height: (size.height / 3) - 170.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentItem.name,
                        style:
                            Style.interNormal(size: 12.sp, color: Style.darker),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        paymentItem.total.toString(),
                        style: Style.interBold(
                            color: Style.titleDark, size: 25.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

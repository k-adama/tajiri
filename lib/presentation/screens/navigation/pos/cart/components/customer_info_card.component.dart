import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/common/utils.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_sdk/src/models/customer.model.dart';

class CustomerInfoCardComponent extends StatelessWidget {
  final Customer? customer;
  final double width;
  const CustomerInfoCardComponent(
      {super.key, required this.customer, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Style.lighter,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300.w,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customer == null
                    ? const EmptyCustomerInfoCard()
                    : DataCustomerInfoCard(
                        customer: customer!,
                        width: width,
                      ),
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
    );
  }
}

class EmptyCustomerInfoCard extends StatelessWidget {
  const EmptyCustomerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Style.coralBlue,
          ),
          child: Center(
              child: SvgPicture.asset("${TrKeysConstant.svgPath}user 1.svg")),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Client de passage",
              style: Style.interBold(
                size: 14.sp,
                color: Style.darker,
              ),
            ),
            Text(
              "Créer/ajouter un client",
              style: Style.interNormal(
                size: 12.sp,
                color: Style.dark,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class DataCustomerInfoCard extends StatelessWidget {
  final Customer customer;
  final double width;
  const DataCustomerInfoCard(
      {super.key, required this.customer, required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Style.coralBlue,
          ),
          child: Center(
            child: Text(
              customer.firstname == null
                  ? getInitialName(customer.lastname)
                  : getInitialName(
                      "${customer.lastname} ${customer.firstname}"),
              style: Style.interBold(
                size: 20.sp,
                color: Style.darker,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.firstname == null
                    ? customer.lastname
                    : "${customer.lastname} ${customer.firstname}",
                style: Style.interBold(
                  size: 14.sp,
                  color: Style.darker,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                customer.phone,
                style: Style.interNormal(
                  size: 12.sp,
                  color: Style.dark,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

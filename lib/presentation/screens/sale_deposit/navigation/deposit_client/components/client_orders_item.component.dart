import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/extensions/string.extension.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class ClientOrdersItemComponent extends StatefulWidget {
  final String? order;
  const ClientOrdersItemComponent({
    super.key,
    this.order,
  });
  @override
  State<ClientOrdersItemComponent> createState() =>
      _ClientOrdersItemComponentState();
}

class _ClientOrdersItemComponentState extends State<ClientOrdersItemComponent> {
  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  bool isExpanded = false;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.r),
        child: Container(
          padding: isExpanded ? null : const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Style.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              collapsedIconColor: Style.black,
              iconColor: Style.black,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderInfoHeaderComponent(),
                  8.verticalSpace,
                  Text(widget.order ?? ""),
                ],
              ),
              subtitle: isExpanded
                  ? null
                  : Row(
                      children: List.generate(3, (index) => null).map((_) {
                        return Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: Text(
                              "Vin de Bordeau x2",
                              style: Style.interNormal(color: Style.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              children: [
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(3, (index) => null).map((_) {
                        return const ClientOrderDetailChipComponent();
                      }).toList(),
                    )),
                20.verticalSpace,
              ],
            ),
          ),
        ));
  }
}

class OrderStatusComponent extends StatelessWidget {
  final String text;
  const OrderStatusComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: tajiriDesignSystem.appColors.mainBlue50,
          border: Border.all(
            color: Style.grey100,
            width: 1,
          ),
          borderRadius: tajiriDesignSystem.appBorderRadius.xs,
        ),
        child: Center(
          child: Text(
            text,
            style: Style.interBold(size: 14),
          ),
        ));
  }
}

class OrderInfoHeaderComponent extends StatelessWidget {
  final String? orderStatus;
  const OrderInfoHeaderComponent({super.key, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "2000".currencyLong(),
                style: Style.interBold(
                  size: 15.sp,
                ),
              ),
              Text(
                "29.08.2024",
                style: Style.interNormal(
                    color: tajiriDesignSystem.appColors.mainGrey400, size: 12),
              ),
            ],
          ),
          OrderStatusComponent(
            text: orderStatus ?? "Non payée",
          ),
        ],
      ),
    );
  }
}

class ClientOrderDetailChipComponent extends StatelessWidget {
  const ClientOrderDetailChipComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: tajiriDesignSystem.appColors.mainGrey100,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Text(
        "Vin de Bordeau x2",
        style: Style.interNormal(
          color: tajiriDesignSystem.appColors.mainGrey700,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class DepositDetailsProduct extends StatefulWidget {
  const DepositDetailsProduct({super.key});

  @override
  State<DepositDetailsProduct> createState() => _DepositDetailsProductState();
}

class _DepositDetailsProductState extends State<DepositDetailsProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Détail du Produit",
          style: Style.interBold(),
        ),
      ),
      body: Container(
        color: Style.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Veuve Cliquot",
                        style: Style.interBold(size: 18),
                      ),
                      24.verticalSpace,
                      const IntrinsicHeight(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CategoriePriceComponent(
                                title: "Small business",
                                value: "150.000 FCFA",
                              ),
                              VerticalDivider(
                                thickness: 1.5,
                                width: 30,
                              ),
                              CategoriePriceComponent(
                                title: "Middle business",
                                value: "160.000 FCFA",
                              ),
                              VerticalDivider(
                                thickness: 1.5,
                                width: 30,
                              ),
                              CategoriePriceComponent(
                                title: "Grand compte",
                                value: "170.000 FCFA",
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      const Divider(),
                      42.verticalSpace,
                      Container(
                        height: 131,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Style.bluebrandColor.withOpacity(.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/product_picture.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      _buildTitle(
                        "Description du produit",
                        "In imperdiet, ex vulputate posuere condimentum, augue velit molestie enim",
                      ),
                      26.verticalSpace,
                      Divider(),
                      26.verticalSpace,
                      _buildTitle(
                        "Stock disponible",
                        "20 casiers",
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(17),
              height: 116,
              decoration: BoxDecoration(
                color: tajiriDesignSystem.appColors.surfaceBackground
                    .withOpacity(.3),
              ),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 48,
                        background: tajiriDesignSystem.appColors.mainBlue500,
                        title: "Modifier le produit",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTitle(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Style.interRegular(color: Colors.grey, size: 14),
        ),
        4.verticalSpace,
        Text(
          value,
          style: Style.interRegular(size: 17),
        ),
      ],
    );
  }
}

class CategoriePriceComponent extends StatelessWidget {
  final String title;
  final String value;

  const CategoriePriceComponent(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Style.interNormal(
            color: tajiriDesignSystem.appColors.mainGrey300,
            size: 14,
          ),
        ),
        Text(
          value,
          style: Style.interBold(
            size: 16,
          ),
        ),
      ],
    );
  }
}

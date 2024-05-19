import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/food_added_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/product_categories_list.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/title.component.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleComponent(),
              const ProductCategorieListComponent(),
              10.verticalSpace,
              const FoodAddedListComponent(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class DepositClientDetailScreen extends StatefulWidget {
  const DepositClientDetailScreen({super.key});

  @override
  State<DepositClientDetailScreen> createState() =>
      _DepositClientDetailScreenState();
}

class _DepositClientDetailScreenState extends State<DepositClientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Le Comptoir Bar & Restaurant",
              style: Style.interBold(size: 20),
            ),
            16.verticalSpace,
          ],
        ),
      )),
    );
  }
}

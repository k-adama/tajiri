import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class StepCardComponent extends StatelessWidget {
  final int currentPage;
  final PageController pageController;

  const StepCardComponent(
      {super.key, required this.currentPage, required this.pageController});

  getTitleStep() {
    if (currentPage == 0) {
      return "Identification";
    } else if (currentPage == 1) {
      return "Prix";
    } else {
      return "Emballage";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: tajiriDesignSystem.appColors.mainYellow500,
        borderRadius: tajiriDesignSystem.appBorderRadius.xs,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Etape ${currentPage + 1}"),
                Text(
                  getTitleStep(),
                  style: Style.interBold(),
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: WormEffect(
                dotWidth: 13,
                dotHeight: 5,
                spacing: 5,
                activeDotColor: tajiriDesignSystem.appColors.mainYellow950,
                dotColor: tajiriDesignSystem.appColors.mainYellow300,
              ),
              onDotClicked: (index) {})
        ],
      ),
    );
  }
}

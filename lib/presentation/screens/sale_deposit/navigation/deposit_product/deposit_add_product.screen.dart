import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_design_system/tajiri_design_system.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/components/step_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_second.dialog.dart';

final tajiriDesignSystem = TajiriDesignSystem.instance;

class DepositAddProductScreen extends StatefulWidget {
  const DepositAddProductScreen({super.key});

  @override
  State<DepositAddProductScreen> createState() =>
      _DepositAddProductScreenState();
}

class _DepositAddProductScreenState extends State<DepositAddProductScreen> {
  PageController pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!.toInt();
      });
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullSecondDialog(
          content: 'Le produit a bien été crée et ajouté à votre compte.',
          title: "Produit créé",
          redirect: () {},
          asset: "assets/svgs/confirmOrderIcon.svg",
          button: CustomButton(
            isUnderline: true,
            textColor: Style.bluebrandColor,
            background: tajiriDesignSystem.appColors.mainBlue50,
            underLineColor: Style.bluebrandColor,
            title: 'Retour à la liste de produits',
            onPressed: () {
              Get.close(2);
            },
          ),
          closePressed: () {
            Get.close(2);
          },
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Nouveau Produit",
          style: Style.interBold(),
        ),
      ),
      body: Container(
        color: Style.white,
        child: Column(
          children: [
            StepCardComponent(
              currentPage: _currentPage,
              pageController: pageController,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(17),
                child: PageView(
                  controller: pageController,
                  children: [
                    Container(),
                    Container(),
                    Container(),
                  ],
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
                    if (_currentPage > 0) ...[
                      Expanded(
                        child: CustomButton(
                          height: 48,
                          haveBorder: true,
                          borderColor: Colors.black,
                          background: Colors.transparent,
                          textColor: Colors.black,
                          title: "Précédent",
                          onPressed: () {
                            _previousPage();
                          },
                        ),
                      ),
                      16.horizontalSpace,
                    ],
                    Expanded(
                      child: CustomButton(
                        height: 48,
                        background: tajiriDesignSystem.appColors.mainBlue500,
                        title: _currentPage == 2 ? "Terminer" : "Suivant",
                        onPressed: () {
                          _nextPage();
                        },
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
}

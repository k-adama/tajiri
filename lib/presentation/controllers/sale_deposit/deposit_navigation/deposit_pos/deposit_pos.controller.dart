import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/components/deposit_categorie_food.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_second.dialog.dart';

class DepositPosController extends GetxController {
  final productIsLoad = false.obs;

  final categories = List<SaleDepositCategorieFood>.empty().obs;
  RxString categoryId = 'all'.obs;

  @override
  void onInit() {
    categories.value = SaleDepositCategorieFood.categories;

    super.onInit();
  }

  void handleFilter(String id, String categoryName) {
    categoryId.value = id;
    update();
  }

  saveOrder(BuildContext context) {
    AppHelpersCommon.showAlertDialog(
      context: context,
      canPop: false,
      child: SuccessfullSecondDialog(
        content: 'La commande à bien été enregistrée au compte du client.',
        title: "Commande enregistrée",
        redirect: () {},
        asset: "assets/svgs/confirmOrderIcon.svg",
        button: CustomButton(
          isUnderline: true,
          textColor: Style.bluebrandColor,
          background: tajiriDesignSystem.appColors.mainBlue50,
          underLineColor: Style.bluebrandColor,
          title: 'Prendre une nouvelle commande',
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

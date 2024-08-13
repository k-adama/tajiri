import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class WaitressController extends GetxController {
  TextEditingController waitressName = TextEditingController();
  TextEditingController editwaitressName = TextEditingController();
  String? selectedGender;
  bool isLoadingCreateWaitress = false;
  bool isLoadingUpdateWaitress = false;
  bool listingEnable = true;
  String? waitressId;
  late Waitress newWaitress;
  final waitressList = List<Waitress>.empty().obs;
  Rx<Waitress?> selectedWaitress = Rx<Waitress?>(null);
  final user = AppHelpersCommon.getUserInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() async {
    fetchWaitress();
    super.onReady();
  }

  clearSelectWaitress() {
    selectedWaitress.value = null;
  }

  Future<void> fetchWaitress() async {
    clearSelectWaitress();
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingCreateWaitress = true;
        update();
        final result = await tajiriSdk.waitressesService.getWaitresses();
        waitressList.assignAll(result);
        isLoadingCreateWaitress = false;
        update();
      } catch (e) {
        isLoadingCreateWaitress = false;
        update();
      }
    }
  }

  Future<void> createWaitress(
      BuildContext context, String? gender, String waitressName) async {
    isLoadingCreateWaitress = true;
    update();

    if (waitressName.isEmpty) {
      isLoadingCreateWaitress = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez saisir le nom",
      );
    }

    if (gender == null) {
      isLoadingCreateWaitress = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez choisir le sexe",
      );
    }
    final CreateWaitressDto createWaitressDto = CreateWaitressDto(
        name: waitressName, gender: gender, restaurantId: restaurantId!);

    try {
      final createWaitress =
          await tajiriSdk.waitressesService.createWaitress(createWaitressDto);
      newWaitress = createWaitress;
      isLoadingCreateWaitress = false;
      update();
      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          haveButton: false,
          isCustomerAdded: false,
          title: "Serveur créé",
          content: "Le serveur $waitressName a bien été ajouté",
          svgPicture: "assets/svgs/waitress-sucess.svg",
          redirect: () {
            Get.close(2);
          },
        ),
      );
      fetchWaitressById(createWaitress.id);
      waitressInitialState();
    } catch (e) {
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        e.toString(),
      );
      isLoadingCreateWaitress = false;
      update();
    }
  }

  Future<void> updateWaitress(BuildContext context, String waitressId) async {
    if (waitressId.isEmpty) return;
    isLoadingUpdateWaitress = true;
    update();
    final UpdateWaitressDto updateWaitressDto = UpdateWaitressDto(
      name: waitressName.text.toString(),
      gender: selectedGender,
    );
    try {
      final result = await tajiriSdk.waitressesService
          .updateWaitress(waitressId, updateWaitressDto);
      isLoadingUpdateWaitress = false;
      update();
      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          haveButton: false,
          isCustomerAdded: false,
          title: "Serveur modifié",
          content: "Le serveur ${waitressName.text} a bien été modifié",
          svgPicture: "assets/svgs/waitress-sucess.svg",
          redirect: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
      updateWaitressList(result);
      waitressInitialState();
    } catch (e) {
      isLoadingCreateWaitress = false;
      update();
      AppHelpersCommon.showBottomSnackBar(
        Get.context!,
        Text(e.toString()),
        const Duration(seconds: 2),
        true,
      );
    }
  }

  Future<void> deleteWaitress(BuildContext context, String waitressId) async {
    if (waitressId.isEmpty) return;
    isLoadingUpdateWaitress = true;
    update();

    await tajiriSdk.waitressesService.deleteWaitress(waitressId);
    isLoadingUpdateWaitress = false;
    update();
    AppHelpersCommon.showAlertDialog(
      context: context,
      canPop: false,
      child: SuccessfullDialog(
        haveButton: false,
        isCustomerAdded: false,
        title: "Serveur supprimé",
        content: "Le serveur ${waitressName.text} a bien été supprimé",
        svgPicture: "assets/svgs/waitress-sucess.svg",
        redirect: () {
          Navigator.pop(context);
          fetchWaitress();
        },
      ),
    );
    waitressList.removeWhere((element) => element.id == waitressId);
    isLoadingUpdateWaitress = false;
    update();
  }

  Future<void> fetchWaitressById(String id) async {
    print("=======fetchWaitressById========");
    clearSelectWaitress();
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        isLoadingCreateWaitress = true;
        update();
        final result = await tajiriSdk.waitressesService.getWaitress(id);
        updateWaitressList(result);
        isLoadingCreateWaitress = false;
        update();
      } catch (e) {
        isLoadingCreateWaitress = false;
        update();
      }
    }
  }

  void updateWaitressList(Waitress waitress) {
    final indexInit =
        waitressList.indexWhere((table) => table.id == waitress.id);
    print("update order list $indexInit");
    if (indexInit != -1) {
      // Replace the old table with the new table in tablesInit
      waitressList[indexInit] = waitress;
    } else {
      // Add the new table to tableInit if it doesn't exist
      waitressList.insert(0, waitress);
    }
  }

  void waitressInitialState() {
    isLoadingCreateWaitress = false;
    waitressName.text = "";
    selectedGender = "";
    update();
  }
}

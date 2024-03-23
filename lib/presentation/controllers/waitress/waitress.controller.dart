import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.dart';
import 'package:tajiri_pos_mobile/data/repositories/waitress/waitress.repository.dart';
import 'package:tajiri_pos_mobile/domain/entities/waitress.entity.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_dialog.dart';

class WaitressController extends GetxController {
  final WaitressRepository _waitressRepository = WaitressRepository();
  TextEditingController waitressName = TextEditingController();
  TextEditingController editwaitressName = TextEditingController();
  String? selectedGender;
  bool isLoadingCreateWaitress = false;
  List waitressOrTableList = [];
  bool listingEnable = true;
  String? waitressId;
  String listingType = "waitress";
  WaitressEntity newWaitress = WaitressEntity();
  final waitress = List<WaitressEntity>.empty().obs;

  final waitressInit = List<WaitressEntity>.empty().obs;
  final waitressById = List<WaitressEntity>.empty().obs;
  Rx<WaitressEntity?> selectedWaitress = Rx<WaitressEntity?>(null);

  @override
  void onInit() async {
    super.onInit();
  }

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
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      isLoadingCreateWaitress = true;
      update();
      final response = await _waitressRepository.getWaitress();

      response.when(
        success: (data) async {
          isLoadingCreateWaitress = false;
          waitress.assignAll(data!);
          waitressInit.assignAll(data);
          isLoadingCreateWaitress = false;
          update();
        },
        failure: (failure, status) {
          isLoadingCreateWaitress = false;
          update();
        },
      );
    }
  }

  Future<void> handleCreateWaitress(BuildContext context) async {
    isLoadingCreateWaitress = true;
    update();
    final user = AppHelpersCommon.getUserInLocalStorage();
    final String? restaurantId = user?.role?.restaurantId;
    if (restaurantId == null) {
      print("restaurantId null");
      return;
    }
    Map<String, dynamic> requestData = {
      "name": waitressName.text.toString(),
      "restaurantId": restaurantId,
      "gender": selectedGender,
    };

    if (waitressName.text.isEmpty) {
      isLoadingCreateWaitress = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez saisir le nom",
      );
    }
    if (selectedGender == null) {
      isLoadingCreateWaitress = false;
      update();
      return AppHelpersCommon.showCheckTopSnackBarInfoForm(
        context,
        "Veuillez choisir le sexe",
      );
    }

    final response = await _waitressRepository.createWaitress(requestData);
    response.when(
      success: (data) async {
        newWaitress = data!;
        isLoadingCreateWaitress = false;
        update();
        AppHelpersCommon.showAlertDialog(
          context: context,
          canPop: false,
          child: SuccessfullDialog(
            haveButton: false,
            isCustomerAdded: false,
            title: "Serveur créé",
            content: "Le serveur ${waitressName.text} a bien été ajouté",
            svgPicture: "assets/svgs/waitress-sucess.svg",
            redirect: () {
              Get.close(2);
            },
          ),
        );
        fetchWaitress();
        waitressInitialState();
      },
      failure: (failure, status) {
        isLoadingCreateWaitress = false;
        update();
        AppHelpersCommon.showCheckTopSnackBar(
          context,
          status.toString(),
        );
      },
    );
  }

  Future<void> updateWaitressName(
      BuildContext context, String tableOrWaitressId) async {
    if (tableOrWaitressId.isEmpty) return;
    isLoadingCreateWaitress = true;
    update();
    Map<String, dynamic> updateData = {
      "name": waitressName.text.toString(),
      "gender": selectedGender,
    };

    final response =
        await _waitressRepository.updateWaitress(updateData, tableOrWaitressId);

    response.when(success: (data) {
      isLoadingCreateWaitress = false;
      waitressId = "";
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
      fetchWaitress();
      waitressInitialState();
    }, failure: (failure, status) {
      AppHelpersCommon.showCheckTopSnackBar(
        context,
        status.toString(),
      );
      isLoadingCreateWaitress = false;
      waitressId = "";
      update();
    });
  }

  Future<void> deleteWaitressName(
      BuildContext context, String waitressId) async {
    if (waitressId.isEmpty) return;
    final response = await _waitressRepository.deleteWaitress(waitressId);
    response.when(success: (data) {
      waitressId = "";
      update();
    }, failure: (failure, status) {
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
            fetchWaitress();
            Navigator.pop(context);
          },
        ),
      );
      waitressId = "";
      update();
    });
  }

  void waitressInitialState() {
    isLoadingCreateWaitress = false;
    waitressName.text = "";
    selectedGender = "";
    update();
  }
}

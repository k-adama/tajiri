import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/pick_image.service.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/custom_field.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/custom_group_field.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/organisation_choice_radio.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_pos/components/product_availability.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/components/add_product_img.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_product/components/step_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_second.dialog.dart';

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
                    const StepOneDepositAddProduct(),
                    const StepSecondDepositAddProduct(),
                    const StepThridDepositAddProduct(),
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
                        title: _currentPage == 2 ? "Enregistrer" : "Suivant",
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

class StepOneDepositAddProduct extends StatefulWidget {
  const StepOneDepositAddProduct({super.key});

  @override
  State<StepOneDepositAddProduct> createState() =>
      _StepOneDepositAddProductState();
}

class _StepOneDepositAddProductState extends State<StepOneDepositAddProduct> {
  XFile? imageProduct;

  Future addProductImage(ImageSource source) async {
    final XFile? image = await PickImageService.getImage(source);
    imageProduct = image;
    setState(() {});
  }

  void showPickerForChooseGalleryOrCamera(BuildContext context) {
    AppHelpersCommon.showAlertDialog(
      context: Get.context!,
      // isTransparent: false,
      canPop: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galerie'),
                  onTap: () {
                    addProductImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Appareil photo'),
                  onTap: () {
                    addProductImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          24.verticalSpace,
          AddProductImgComponent(
              file: imageProduct,
              addProductTap: () {
                showPickerForChooseGalleryOrCamera(context);
              }),
          24.verticalSpace,
          CustomFieldWidget(
            title: "Quel est le nom du produit ?",
            hintText: "Nom",
            controller: TextEditingController(),
          ),
          24.verticalSpace,
          CustomFieldWidget(
            title: "Comment décrivez-vous le produit ?",
            hintText: "Description",
            controller: TextEditingController(),
          ),
          24.verticalSpace,
          CustomFieldWidget(
            title: "Dans quel catégorie se trouve le produit ?",
            hintText: "Catégorie",
            controller: TextEditingController(),
          ),
        ],
      ),
    );
  }
}

class StepSecondDepositAddProduct extends StatefulWidget {
  const StepSecondDepositAddProduct({super.key});

  @override
  State<StepSecondDepositAddProduct> createState() =>
      _StepSecondDepositAddProductState();
}

class _StepSecondDepositAddProductState
    extends State<StepSecondDepositAddProduct> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text(
          "Indiquez les prix du produit selon les catégories de client que vous avez.",
          style: Style.interRegular(size: 22),
        ),
        24.verticalSpace,
        ...Organisation.fakeData.map((e) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _groupTag(e.name),
                CustomFieldWidget(
                  title: "Combien coûte ce produit ?",
                  hintText: "Prix",
                  controller: TextEditingController(),
                ),
                24.verticalSpace,
                const Divider(),
                24.verticalSpace,
              ],
            )),
      ],
    ));
  }

  _groupTag(String groupName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: tajiriDesignSystem.appColors.mainYellow100,
          borderRadius: tajiriDesignSystem.appBorderRadius.lg),
      child: Text(groupName, style: Style.interBold(size: 12)),
    );
  }
}

class StepThridDepositAddProduct extends StatefulWidget {
  const StepThridDepositAddProduct({super.key});

  @override
  State<StepThridDepositAddProduct> createState() =>
      _StepThridDepositAddProductState();
}

class _StepThridDepositAddProductState
    extends State<StepThridDepositAddProduct> {
  bool isAvailable = true;
  bool isConsigned = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        24.verticalSpace,
        CustomGroupFieldComponent(
          title: "L’emballage du produit est-il consigné ?",
          field: Row(
            children: [
              CustomChooseYesOrNotComponent(
                text: 'Oui',
                onTap: () {
                  setState(() {
                    isConsigned = true;
                  });
                },
                isSelected: isConsigned == true,
              ),
              14.horizontalSpace,
              CustomChooseYesOrNotComponent(
                text: 'Non',
                onTap: () {
                  setState(() {
                    isConsigned = false;
                  });
                },
                isSelected: isConsigned == false,
              ),
            ],
          ),
        ),
        if (isConsigned) ...[
          24.verticalSpace,
          CustomFieldWidget(
            title: "Combien coûte la consignation (emballage) ?",
            hintText: "Prix de la consignation",
            controller: TextEditingController(),
          ),
        ],
        24.verticalSpace,
        const Divider(),
        24.verticalSpace,
        CustomGroupFieldComponent(
          title: "Le produit est-il disponible ?",
          field: Row(
            children: [
              CustomChooseYesOrNotComponent(
                text: 'Oui',
                onTap: () {
                  setState(() {
                    isAvailable = true;
                  });
                },
                isSelected: isAvailable == true,
              ),
              14.horizontalSpace,
              CustomChooseYesOrNotComponent(
                text: 'Non',
                onTap: () {
                  setState(() {
                    isAvailable = false;
                  });
                },
                isSelected: isAvailable == false,
              ),
            ],
          ),
        ),
        24.verticalSpace,
        CustomFieldWidget(
          title: "Quel est le stock disponible ?",
          hintText: "Quantité du produit",
          controller: TextEditingController(),
        ),
      ]),
    );
  }
}

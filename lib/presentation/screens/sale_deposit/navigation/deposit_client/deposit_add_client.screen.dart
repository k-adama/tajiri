import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/add_group.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/add_group_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/custom_field.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/organisation_choice_radio.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/successfull_second.dialog.dart';

class DepositAddClientScreen extends StatefulWidget {
  const DepositAddClientScreen({super.key});

  @override
  State<DepositAddClientScreen> createState() => _DepositAddClientScreenState();
}

class _DepositAddClientScreenState extends State<DepositAddClientScreen> {
  String? _selectedOrganisationId;
  void _onOrganisationChanged(String? value) {
    setState(() {
      _selectedOrganisationId = value;
    });
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
          "Nouveau Client",
          style: Style.interBold(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(
                      title: 'Identification',
                      description:
                          'Renseigner les informations de base du client (nom, contact, adresse ...)',
                    ),
                    24.verticalSpace,
                    CustomFieldWidget(
                      title: 'Nom ou Raison sociale',
                      hintText: "Nom de l’établissement",
                      controller: TextEditingController(),
                    ),
                    24.verticalSpace,
                    CustomFieldWidget(
                      title: 'Nom du référent',
                      hintText: "Nom du Propriétaire/Gérant ",
                      controller: TextEditingController(),
                    ),
                    24.verticalSpace,
                    CustomFieldWidget(
                      title: 'Adresse géographique',
                      hintText: "ex. Abidjan Cocody Anono",
                      controller: TextEditingController(),
                    ),
                    24.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                            child: CustomFieldWidget(
                          title: 'Téléphone 1',
                          prefixIcon: SvgPicture.asset(
                            "assets/svgs/mobile-ic.svg",
                            width: 30,
                          ),
                          keyboardType: TextInputType.phone,
                          hintText: "0000000000",
                          controller: TextEditingController(),
                        )),
                        14.horizontalSpace,
                        Expanded(
                            child: CustomFieldWidget(
                          title: 'Téléphone 2',
                          prefixIcon: SvgPicture.asset(
                            "assets/svgs/mobile-ic.svg",
                            width: 30,
                          ),
                          keyboardType: TextInputType.phone,
                          hintText: "0000000000",
                          controller: TextEditingController(),
                        )),
                      ],
                    ),
                    24.verticalSpace,
                    const Divider(),
                    24.verticalSpace,
                    _buildTitle(
                      title: 'organisation',
                      description:
                          'Définissez le type et la catégorie du client (Small business, Grand compte ...)',
                    ),
                    24.verticalSpace,
                    Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          ...Organisation.fakeData
                              .map(
                                (e) => OrganisationChoiceRadioComponent(
                                  organisation: e,
                                  onChanged: _onOrganisationChanged,
                                  selectedId: _selectedOrganisationId,
                                ),
                              )
                              .toList(),
                          AddGroudButton(onTap: () {
                            AppHelpersCommon.showCustomModalBottomSheet(
                              context: context,
                              modal: const AddGroupModalComponent(),
                              isDarkMode: false,
                              isDrag: true,
                              radius: 12,
                            );
                          }),
                        ],
                      ),
                    ),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(17),
              height: 116,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 48,
                        background: tajiriDesignSystem.appColors.mainBlue500,
                        title: "Enregistrer le client",
                        onPressed: () {
                          AppHelpersCommon.showAlertDialog(
                            context: context,
                            canPop: false,
                            child: SuccessfullSecondDialog(
                              content: 'Le client a été enregistré avec succès',
                              title: "Client enregistré",
                              redirect: () {},
                              asset: "assets/svgs/confirmOrderIcon.svg",
                              button: CustomButton(
                                isUnderline: true,
                                textColor: Style.bluebrandColor,
                                background:
                                    tajiriDesignSystem.appColors.mainBlue50,
                                underLineColor: Style.bluebrandColor,
                                title: 'Retour',
                                onPressed: () {
                                  Get.close(2);
                                },
                              ),
                              closePressed: () {
                                Get.close(2);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTitle({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Style.interBold(),
        ),
        Text(
          description,
          style: Style.interNormal(color: Colors.grey, size: 14),
        ),
      ],
    );
  }
}

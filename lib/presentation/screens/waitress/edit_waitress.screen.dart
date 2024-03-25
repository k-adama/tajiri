import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/gender_selection_component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/textfield_waitress.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class EditWaitressScreen extends StatefulWidget {
  const EditWaitressScreen({super.key});

  @override
  State<EditWaitressScreen> createState() => _EditWaitressScreenState();
}

class _EditWaitressScreenState extends State<EditWaitressScreen> {
  WaitressController waitressController = Get.find();
  final listData = Get.arguments;

  @override
  void initState() {
    super.initState();
    waitressController.waitressName.text = listData['name'];
    waitressController.selectedGender = listData['gender'];
    waitressController.waitressId = listData['id'];
  }

  void selectGender(String gender) {
    setState(() {
      waitressController.selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GetBuilder<WaitressController>(
        builder: (_waitressController) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,
                  Text(
                    "Modification du serveur",
                    style: Style.interBold(size: 26.sp, color: Style.darker),
                  ),
                  12.verticalSpace,
                  Text(
                    "Sexe",
                    style: Style.interBold(size: 16.sp, color: Style.darker),
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      GenderSelectionComponent(
                          text: 'Homme',
                          iconPath: 'assets/svgs/noto_man.svg',
                          onTap: () => selectGender('MALE'),
                          isSelected:
                              _waitressController.selectedGender == 'MALE'),
                      SizedBox(width: 16.0.w),
                      GenderSelectionComponent(
                          text: 'Femme',
                          iconPath: 'assets/svgs/noto_woman.svg',
                          onTap: () => selectGender('FEMALE'),
                          isSelected:
                              _waitressController.selectedGender == 'FEMALE'),
                    ],
                  ),
                  TextFieldWaitressComponent(
                    label: "Nom",
                    optionalLabel: null,
                    hint: "Nom complet du serveur",
                    initialValue: waitressController.waitressName.text,
                    controller: waitressController.waitressName,
                  ),
                  330.verticalSpace,
                  Container(
                    height: 55.h,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: CustomButton(
                      isLoading: waitressController.isLoadingCreateWaitress,
                      background: Style.primaryColor,
                      title: "Enregistrer",
                      textColor: Style.secondaryColor,
                      isLoadingColor: Style.secondaryColor,
                      radius: 5,
                      onPressed: () {
                        print(waitressController.selectedGender);
                        _waitressController.updateWaitressName(
                            context, waitressController.waitressId!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/custom_field.text_field.dart';

class EditTableScreen extends StatefulWidget {
  const EditTableScreen({super.key});

  @override
  State<EditTableScreen> createState() => _EditTableScreenState();
}

class _EditTableScreenState extends State<EditTableScreen> {
  TableController tableController = Get.find();
  final tableData = Get.arguments;
  @override
  void initState() {
    super.initState();
    tableController.tableName = tableData['name'];
    tableController.tableDescription = tableData['description'];
    tableController.tableNumberOfPlace = tableData['persons'];
    tableController.tableId = tableData['id'];
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
      body: GetBuilder<TableController>(
        builder: (_tableController) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,
                  Text(
                    "Modification de la table",
                    style: Style.interBold(
                      size: 26.sp,
                      color: Style.darker,
                    ),
                  ),
                  15.verticalSpace,
                  CustomTextField(
                    label: 'Nom',
                    optionalLabel: null,
                    hint: 'Nom de la table',
                    value: _tableController.tableName,
                    onChange: (text) {
                      tableController.setTableName(text);
                    },
                    keyboardType: TextInputType.text,
                  ),
                  CustomTextField(
                    label: 'Description',
                    optionalLabel: null,
                    hint: 'Description',
                    value: _tableController.tableDescription,
                    onChange: (text) {
                      tableController.setTableDescription(text);
                    },
                    keyboardType: TextInputType.multiline,
                  ),
                  CustomTextField(
                    label: 'Nombre de siège',
                    optionalLabel: null,
                    hint: 'Nombre de place',
                    value: _tableController.tableNumberOfPlace,
                    onChange: (text) {
                      tableController.setTableNumberPlace(text);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  94.verticalSpace,
                  Container(
                    height: 45.h,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: CustomButton(
                      isLoading: _tableController.isLoadingEdetingTable,
                      background: Style.primaryColor,
                      title: "Enregistrer",
                      textColor: Style.secondaryColor,
                      isLoadingColor: Style.secondaryColor,
                      radius: 5,
                      onPressed: () {
                        _tableController.updateTable(
                            context, tableController.tableId!);
                      },
                    ),
                  ),
                  Container(
                    height: 45.h,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: CustomButton(
                      isLoading: _tableController.isLoadingDeleteTable,
                      background: Style.white,
                      borderColor: Style.secondaryColor,
                      title: "Supprimer la table",
                      textColor: Style.secondaryColor,
                      isLoadingColor: Style.secondaryColor,
                      radius: 5,
                      onPressed: () {
                        _tableController.deleteTable(
                            context, tableController.tableId!);
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

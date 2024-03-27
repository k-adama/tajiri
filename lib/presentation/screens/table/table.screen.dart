import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/table/components/add_table_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/table/components/table_board.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer/table_card_shimmer.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgGrey,
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
        builder: (tableController) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Liste des tables",
                  style: Style.interBold(size: 25),
                ),
              ),
              Expanded(
                child: tableController.isLoadingTable
                    ? GridView.builder(
                        padding: EdgeInsets.only(
                            right: 12.w, left: 12.w, bottom: 96.h, top: 24.r),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.66.r,
                          crossAxisCount: 2,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const TableCardShimmer();
                        },
                      )
                    // const ShimmerProductListWidget()
                    : const TablesBoardComponent(),
              ),
              Container(
                height: 55.h,
                margin: const EdgeInsets.only(bottom: 30),
                child: CustomButton(
                  background: Style.primaryColor,
                  title: "Créer une nouvelle table",
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  radius: 5,
                  onPressed: () {
                    AppHelpersCommon.showCustomModalBottomSheet(
                      context: context,
                      modal: const AddTableModalComponent(),
                      isDarkMode: false,
                      isDrag: true,
                      radius: 12.r,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

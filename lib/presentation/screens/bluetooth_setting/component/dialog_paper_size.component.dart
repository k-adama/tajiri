import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/paper_entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/bluetooth_setting/bluetooth_setting.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/component/paper_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class DialogPaperSizeComponent extends StatefulWidget {
  final VoidCallback connectPrinter;
  const DialogPaperSizeComponent({super.key, required this.connectPrinter});

  @override
  State<DialogPaperSizeComponent> createState() =>
      _DialogPaperSizeComponentState();
}

class _DialogPaperSizeComponentState extends State<DialogPaperSizeComponent> {
  PaperSize? selectPaperSize;

  static final PaperEntity paper58 = PaperEntity(
    "assets/svgs/58_paper_size.svg",
    "Papier 58 mm",
    paperSize: PaperSize.mm58,
  );
  static final PaperEntity paper80 = PaperEntity(
    "assets/svgs/80_paper_size.svg",
    "Papier 80 mm",
    paperSize: PaperSize.mm80,
  );

  final List<PaperEntity> paperList = [
    paper58,
    paper80,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectPaperSize = await AppHelpersCommon.getPaperSize();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BluetoothSettingController>(
        builder: (bluetoothSettingController) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          "Veuillez choisir la taille du papier présent dans l’imprimante",
          style: Style.interNormal(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: PaperCardComponent(
                  paper: paper58,
                  onPressed: () {
                    selectPaperSize = paper58.paperSize;
                    setState(() {});
                  },
                  isSelect: selectPaperSize == paper58.paperSize,
                )),
                const SizedBox(width: 5),
                Expanded(
                    child: PaperCardComponent(
                  paper: paper80,
                  onPressed: () {
                    selectPaperSize = paper80.paperSize;
                    setState(() {});
                  },
                  isSelect: selectPaperSize == paper80.paperSize,
                )),
              ],
            ),
            22.verticalSpace,
            CustomButton(
              title: 'Connecter l’imprimante',
              textColor: Style.white,
              isGrised: selectPaperSize == null,
              background: Style.secondaryColor,
              weight: 20,
              radius: 3,
              isLoading: false,
              onPressed: () {
                widget.connectPrinter();
                bluetoothSettingController.setSelectSizePaper(selectPaperSize!);
                Get.back();
              },
            )
          ],
        ),
      );
    });
  }
}

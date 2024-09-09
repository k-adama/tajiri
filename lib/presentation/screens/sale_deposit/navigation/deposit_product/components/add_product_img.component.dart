import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/components/add_icon.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';

class AddProductImgComponent extends StatelessWidget {
  final XFile? file;
  final VoidCallback addProductTap;
  final String? imageUrl;
  final String text;
  const AddProductImgComponent(
      {super.key,
      required this.file,
      required this.addProductTap,
      this.imageUrl,
      this.text = "Ajouter l' image du produit"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addProductTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
            color: tajiriDesignSystem.appColors.mainGrey50,
            borderRadius: tajiriDesignSystem.appBorderRadius.sm),
        child: file != null
            ? Image.file(
                File(file!.path),
                fit: BoxFit.cover,
              )
            : imageUrl != null
                ? CustomNetworkImageUi(
                    radius: 0,
                    url: imageUrl!,
                    width: double.infinity,
                    height: 50,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AddIconComponent(
                        color: tajiriDesignSystem.appColors.mainBlue500,
                        margin: EdgeInsets.zero,
                      ),
                      8.horizontalSpace,
                      Flexible(
                        child: Text(
                          text,
                          style: Style.interBold(
                              size: 16,
                              color: tajiriDesignSystem.appColors.mainBlue500),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}

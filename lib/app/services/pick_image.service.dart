// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/dialogs/management_alert.dialog.dart';

class PickImageService {
  static const PHOTO_ACCESS_DENIED_CODE = "photo_access_denied";
  static const CAMERA_ACCESS_DENIED_IMAGEPICKER = "camera_access_denied";

  static Future<XFile?> getImage(ImageSource imageSource) async {
    try {
      XFile? xfile =
          await ImagePicker.platform.getImageFromSource(source: imageSource);
      if (xfile != null) {
        final imgCompres = await compressAndGetFile(xfile);
        return imgCompres;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      if (e.code == CAMERA_ACCESS_DENIED_IMAGEPICKER) {
        AppHelpersCommon.showAlertDialog(
          context: Get.context!,
          isTransparent: false,
          canPop: false,
          child: ManagementDialog(
            title: "Permission non accordée",
            content:
                "Vous devez autoriser l'accès à votre caméra avant de continuer",
            button: CustomButton(
              isUnderline: true,
              textColor: Style.bluebrandColor,
              background: tajiriDesignSystem.appColors.mainBlue50,
              underLineColor: Style.bluebrandColor,
              title: 'Aller dans les paramètres',
              onPressed: () {
                openAppSettings();
              },
            ),
            redirect: null,
            closePressed: () {
              Get.close(1);
            },
          ),
        );
      } else {
        print(e.message ?? "Un problème est survenue");
      }

      return null;
    }
  }

  static Future<List<XFile>?> getMultiImage(int maxNumber) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final List<XFile> selectedImages = await imagePicker.pickMultiImage();

      if (selectedImages.length > maxNumber) {
        print("Vous ne pouvez selectionner que $maxNumber image(s)");
        return null;
      }
      List<XFile> res = [];
      await Future.forEach<XFile>(selectedImages, (image) async {
        final imgCompres = await compressAndGetFile(image);
        res.add(imgCompres);
      });
      return res;
    } on PlatformException catch (e) {
      if (e.code == PHOTO_ACCESS_DENIED_CODE) {
        AppHelpersCommon.showAlertDialog(
          context: Get.context!,
          isTransparent: false,
          canPop: false,
          child: ManagementDialog(
            title: "Permission non accordée",
            content:
                "Vous devez autoriser l'accès à votre librairie photo avant de continuer",
            button: CustomButton(
              isUnderline: true,
              textColor: Style.bluebrandColor,
              background: tajiriDesignSystem.appColors.mainBlue50,
              underLineColor: Style.bluebrandColor,
              title: 'Aller dans les paramètres',
              onPressed: () {
                openAppSettings();
              },
            ),
            redirect: null,
            closePressed: () {
              Get.close(1);
            },
          ),
        );
      } else {
        print(e.message ?? "Un problème est survenue");
      }

      return null;
    }
  }

  static Future<XFile> compressAndGetFile(XFile file,
      {int quality = 80}) async {
    print("-----------------Compression quality : $quality-------------");
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf('.');
    final extension = filePath.substring(lastIndex);
    final fileName = filePath.substring(0, lastIndex);
    final outPath = '${fileName}_out$extension';
    print("-----------------fichier de sortie : $outPath-------------");

    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: quality,
      );

      if (result != null) {
        return result;
      } else {
        throw "Une erreur est survenue au niveau de la compression";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return file;
    }
  }
}

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

class PaperEntity {
  final PaperSize paperSize;
  final String asset;
  final String title;

  PaperEntity(this.asset, this.title, {required this.paperSize});
}

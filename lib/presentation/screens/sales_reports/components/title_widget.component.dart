import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/sales_reports_draw.component.dart';

class SalesTitleWidgetComponent extends StatefulWidget {
  final double? height;
  final double width;
  final double? radius;
  final String title;
  final Widget component;
  const SalesTitleWidgetComponent(
      {Key? key,
      required this.height,
      required this.width,
      required this.title,
      required this.component,
      this.radius})
      : super(key: key);

  @override
  State<SalesTitleWidgetComponent> createState() => _SalesTitleWidgetComponentState();
}

class _SalesTitleWidgetComponentState extends State<SalesTitleWidgetComponent> {
  GlobalKey textKey = GlobalKey();
  double textHeight = 0.0;
  double textWidth = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final textKeyContext = textKey.currentContext;
        if (textKeyContext != null) {
          final box = textKeyContext.findRenderObject() as RenderBox;
          textHeight = box.size.height;
          textWidth = box.size.width;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topLeft,
      children: [
        CustomPaint(
          child: Container(
            height: widget.height,
            width: widget.width,
          ),
          painter: SalesReportsDraw(
            Style.light,
            textWidth,
            radius: widget.radius ?? 0,
          ),
        ),
        Positioned(
          top: -textHeight + 10.h,
          left: textHeight + 10.h,
          child: Padding(
            key: textKey,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.title,
              style: Style.interBold(),
            ),
          ),
        ),
        widget.component
      ],
    );
  }
}

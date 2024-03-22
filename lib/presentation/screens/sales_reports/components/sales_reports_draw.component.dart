import 'package:flutter/material.dart';

class SalesReportsDraw extends CustomPainter {
  late Paint painter;
  late double radius;
  late double textWidth;

  SalesReportsDraw(Color color, this.textWidth, {this.radius = 0}) {
    painter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    textWidth > 68 ? path.moveTo(size.width - ((size.width - 110)), 0) : path.moveTo(size.width - ((size.width - 90)), 0);

    path.lineTo(size.width - radius, 0);
    path.cubicTo(size.width - radius, 0, size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.cubicTo(size.width, size.height - radius, size.width, size.height,
        size.width - radius, size.height);

    path.lineTo(radius, size.height);
    path.cubicTo(radius, size.height, 0, size.height, 0, size.height - radius);

    path.lineTo(0, radius);
    path.cubicTo(0, radius, 0, 0, radius, 0);
    path.lineTo(((size.width - 50) - 300), 0);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
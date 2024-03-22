import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWrapWidget extends StatelessWidget {
  final Widget child;
  final BorderRadius radius;
  final double blur;

  const BlurWrapWidget({
    Key? key,
    required this.child,
    required this.radius,
    this.blur = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
}

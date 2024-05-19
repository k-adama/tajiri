import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomPaginationComponentBuilder extends SwiperPlugin {
  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 1000),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                config.itemCount, (int index) => _buildDot(config, index)),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(SwiperPluginConfig config, int index) {
    bool isActive = config.activeIndex == index;

    double size = isActive ? 8.0 : 15.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceInOut,
      width: isActive ? 20.0 : 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
          color: Style.dark,
          borderRadius:
              isActive ? BorderRadius.circular(5) : BorderRadius.circular(10)),
      onEnd: () {
        size = isActive ? 12.0 : 8.0;
      },
    );
  }
}

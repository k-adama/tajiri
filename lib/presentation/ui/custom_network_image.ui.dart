import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class CustomNetworkImageUI extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final double radius;
  final Color bgColor;
  final bool isRaduisTopLef;
  final bool mustSaturation;

  const CustomNetworkImageUI({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    required this.radius,
    this.mustSaturation = true,
    this.isRaduisTopLef = false,
    this.bgColor = Style.mainBack,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = AppHelpersCommon.checkIsSvg(url)
        ? SvgPicture.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: Style.shimmerBase,
              ),
            ),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: url,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Style.shimmerBase,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: bgColor,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  FlutterRemix.image_line,
                  color: Style.shimmerBaseDark,
                ),
              );
            },
          );

    if (mustSaturation) {
      return ClipRRect(
        borderRadius: isRaduisTopLef
            ? BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              )
            : BorderRadius.circular(radius),
        child: imageWidget,
      );
    } else {
      return ClipRRect(
        borderRadius: isRaduisTopLef
            ? BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              )
            : BorderRadius.circular(radius),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Style.white,
            BlendMode.saturation,
          ),
          child: imageWidget,
        ),
      );
    }
  }
}

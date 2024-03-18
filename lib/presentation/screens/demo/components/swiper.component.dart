import 'package:flutter/widgets.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/demo/components/custom_pagination_builder.component.dart';

class SwiperComponent extends StatelessWidget {
  const SwiperComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final SwiperController _swiperController = SwiperController();
    final size = MediaQuery.of(context).size;
    return Container(
              height: MediaQuery.of(context).size.height - 220.h,
              child: Swiper(
                autoplay: true,
                autoplayDelay: 3000,
                controller: _swiperController,
                itemBuilder: (BuildContext context, int index) {
                  final swiperData = SWIPERDATA[index];
                  return Column(
                    children: [
                      Text(
                        swiperData['title'],
                        style: Style.interBold(size: 17, color: Style.darker),
                      ),
                      Center(
                        child: Text(
                          swiperData['content'],
                          style:
                              Style.interNormal(size: 35, color: Style.darker),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Center(
                        child: Text(
                          swiperData['secondcontent'] ?? "",
                          style:
                              Style.interNormal(size: 35, color: Style.darker),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: size.height / 2,
                        width: double.infinity,
                        child: Center(
                            child: SvgPicture.asset(
                          swiperData['image'],
                        )),
                      )
                    ],
                  );
                },
                itemCount: 3,
                pagination:
                    SwiperPagination(builder: CustomPaginationComponentBuilder()),
                control: const SwiperControl(
                  size: 0,
                ),
              ),
            );
  }
}
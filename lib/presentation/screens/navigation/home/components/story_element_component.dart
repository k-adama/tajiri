import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/story.entity.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/shop_avatar.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/loading.ui.dart';

class StoryElementComponent extends StatefulWidget {
  final List<StoryEntity?>? story;
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  const StoryElementComponent(
      {super.key,
      required this.story,
      required this.nextPage,
      required this.prevPage});

  @override
  State<StoryElementComponent> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryElementComponent>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final pageController = PageController(initialPage: 0);
  GlobalKey imageKey = GlobalKey();
  int currentIndex = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..addListener(() {
        if (controller.status == AnimationStatus.completed) {
          if (currentIndex == widget.story!.length - 1) {
            widget.nextPage();
          } else {
            currentIndex++;
            controller.reset();
            controller.forward();
          }
        }
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
    setLocalJiffy();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  setLocalJiffy() async {
    await Jiffy.locale('fr');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.story?[currentIndex]?.url ??
              "https://images.unsplash.com/photo-1695042092180-c86f5e4df563?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=800&q=60",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          imageBuilder: (context, image) {
            return Stack(
              key: imageKey,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: image, fit: BoxFit.fitWidth),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Container(
                      height: 4.h,
                      color: Style.transparent,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.story?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              margin: EdgeInsets.only(right: 8.w),
                              height: 4.h,
                              width: (MediaQuery.of(context).size.width -
                                      (36.w +
                                          ((widget.story!.length == 1
                                                  ? widget.story!.length
                                                  : (widget.story!.length -
                                                      1)) *
                                              8.w))) /
                                  widget.story!.length,
                              decoration: BoxDecoration(
                                color: currentIndex >= index
                                    ? Style.primaryColor
                                    : Style.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(122.r)),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: currentIndex == index
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(122.r)),
                                      child: LinearProgressIndicator(
                                        value: controller.value,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Style.primaryColor),
                                        backgroundColor: Style.white,
                                      ),
                                    )
                                  : currentIndex > index
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(122.r)),
                                          child: const LinearProgressIndicator(
                                            value: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Style.primaryColor),
                                            backgroundColor: Style.white,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            );
          },
          progressIndicatorBuilder: (context, url, progress) {
            return const LoadingUi();
          },
          errorWidget: (context, url, error) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Style.textGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterRemix.image_line,
                        color: Style.white,
                        size: 32.r,
                      ),
                      8.verticalSpace,
                      Text(
                        "Pas de resultats",
                        style: Style.interNormal(color: Style.white),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Container(
                      height: 4.h,
                      color: Style.transparent,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.story?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              margin: EdgeInsets.only(right: 8.w),
                              height: 4.h,
                              width: (MediaQuery.of(context).size.width -
                                      (36.w +
                                          ((widget.story!.length == 1
                                                  ? widget.story!.length
                                                  : (widget.story!.length -
                                                      1)) *
                                              8.w))) /
                                  widget.story!.length,
                              decoration: BoxDecoration(
                                color: currentIndex >= index
                                    ? Style.brandGreen
                                    : Style.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(122.r)),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: currentIndex == index
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(122.r)),
                                      child: LinearProgressIndicator(
                                        value: controller.value,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Style.brandGreen),
                                        backgroundColor: Style.white,
                                      ),
                                    )
                                  : currentIndex > index
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(122.r)),
                                          child: const LinearProgressIndicator(
                                            value: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Style.brandGreen),
                                            backgroundColor: Style.white,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            GestureDetector(
              onLongPressStart: (s) {
                controller.stop();
              },
              onLongPressEnd: (s) {
                controller.forward();
              },
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex--;
                  controller.reset();
                  controller.forward();
                  setState(() {});
                } else {
                  widget.prevPage();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Style.transparent,
              ),
            ),
            GestureDetector(
              onLongPressStart: (s) {
                controller.stop();
              },
              onLongPressEnd: (s) {
                controller.forward();
              },
              onTap: () {
                if (currentIndex != widget.story!.length - 1) {
                  currentIndex++;
                  controller.reset();
                  controller.forward();
                  setState(() {});
                } else {
                  widget.nextPage();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Style.transparent,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      /*  context.pushRoute(ShopRoute(
                          shopId: (widget.story?.first?.shopId ?? 0))); */
                    },
                    child: Row(
                      children: [
                        6.horizontalSpace,
                        ShopAvatarComponent(
                          shopImage: widget.story?.first?.logoImg ?? "",
                          size: 46.r,
                          padding: 5.r,
                          bgColor: Style.tabBarBorderColor.withOpacity(0.6),
                        ),
                        6.horizontalSpace,
                        Text(
                          widget.story?.first?.title ?? "",
                          style: Style.interNormal(
                              size: 14.sp, color: Style.white),
                        ),
                        6.horizontalSpace,
                        Text(
                          Jiffy(widget.story?[currentIndex]?.createdAt ??
                                  DateTime.now())
                              .fromNow(),
                          style: Style.interNormal(
                              size: 10.sp, color: Style.white),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Style.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8.r, bottom: 8.r, left: 8.r, right: 4.r),
                        child: const Icon(
                          Icons.close,
                          color: Style.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

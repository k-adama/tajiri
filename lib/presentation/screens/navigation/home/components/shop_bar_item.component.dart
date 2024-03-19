import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/domain/entities/story.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/shop_avatar.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/story.screen.dart';

class ShopBarItemComponent extends StatelessWidget {
  final RefreshController controller;
  final StoryEntity? story;
  final int index;
  final HomeController homeController;

  const ShopBarItemComponent({
    super.key,
    required this.story,
    required this.controller,
    required this.index,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await homeController.fetchStoriesById(story?.productUuid ?? '');
        Mixpanel.instance.track("Status viewed",
            properties: {"Canal viewed": story?.title, "Status": "Succes"});
        // Get.toNamed(Routes.STORY_PAGE);
        Get.to(const StoryScreen());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Style.primaryColor, width: 2.r)),
              child: ShopAvatarComponent(
                shopImage: story?.logoImg ?? "",
                size: 64,
                padding: 6,
                radius: 32,
                bgColor: Style.transparent,
              ),
            ),
            10.verticalSpace,
            SizedBox(
              width: 72.r,
              child: Center(
                child: Text(
                  story?.title ?? "",
                  style: Style.interNormal(
                    size: 12,
                    color: Style.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

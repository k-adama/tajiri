import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/add_waitress_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/shimmer_product_list.widget.dart';

class WaitressScreen extends StatefulWidget {
  const WaitressScreen({super.key});

  @override
  State<WaitressScreen> createState() => _WaitressScreenState();
}

class _WaitressScreenState extends State<WaitressScreen> {
  final WaitressController waitressController = Get.find();
  final RefreshController _controller = RefreshController();
  void _onRefresh() async {
    waitressController.fetchWaitress();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    waitressController.fetchWaitress();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Style.black),
        backgroundColor: Style.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GetBuilder<WaitressController>(
        builder: (_waitressController) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Liste des serveurs",
                    style: Style.interBold(size: 25),
                  )),
              Expanded(
                child: _waitressController.isLoadingCreateWaitress
                    ? const ShimmerProductListWidget()
                    : SmartRefresher(
                        controller: _controller,
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: ListView.builder(
                          itemCount: _waitressController.waitress.length,
                          itemBuilder: (context, index) {
                            final waitress =
                                _waitressController.waitress[index];
                            return Container(
                              padding: const EdgeInsets.all(6.0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  waitress.gender != null &&
                                          waitress.gender == 'MALE'
                                      ? SvgPicture.asset(
                                          'assets/svgs/noto_man.svg')
                                      : SvgPicture.asset(
                                          'assets/svgs/noto_woman.svg'),
                                  SizedBox(width: 8.0.w),
                                  Expanded(
                                    child: Text(waitress.name ?? "",
                                        style: Style.interBold(
                                          size: 15,
                                        )),
                                  ),
                                  PopupMenuButton(
                                    icon: const Icon(Icons.more_horiz),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/edit_waitress.svg'),
                                              8.horizontalSpace,
                                              const Text('Modifier'),
                                            ],
                                          )),
                                      PopupMenuDivider(
                                        height: 10.h,
                                      ),
                                      PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/delete_waitress.svg'),
                                              8.horizontalSpace,
                                              const Text('Supprimer'),
                                            ],
                                          )),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Get.toNamed(Routes.EDIT_WAITRESS,
                                            arguments: {
                                              'id': waitress.id,
                                              'name': waitress.name ?? "",
                                              'gender': waitress.gender,
                                            });
                                      } else if (value == 'delete') {
                                        _waitressController.deleteWaitressName(
                                            context, waitress.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
              ),
              Container(
                height: 55.h,
                margin: const EdgeInsets.only(bottom: 30),
                child: CustomButton(
                  background: Style.primaryColor,
                  title: "Créer un nouveau serveur",
                  textColor: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  radius: 5,
                  onPressed: () {
                    AppHelpersCommon.showCustomModalBottomSheet(
                      context: context,
                      modal: const AddWaitressModalComponent(),
                      isDarkMode: false,
                      isDrag: true,
                      radius: 12.r,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

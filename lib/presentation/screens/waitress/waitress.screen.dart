import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/add_waitress_modal.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/components/waitress_card.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer/waitress_card.shimmer.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class WaitressScreen extends StatefulWidget {
  const WaitressScreen({super.key});

  @override
  State<WaitressScreen> createState() => _WaitressScreenState();
}

class _WaitressScreenState extends State<WaitressScreen> {
  final RefreshController _controller = RefreshController();
  void _onRefresh(WaitressController waitressController) async {
    waitressController.fetchWaitress();
    _controller.refreshCompleted();
  }

  void _onLoading(WaitressController waitressController) async {
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
        builder: (waitressController) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Liste des serveurs",
                  style: Style.interBold(size: 25),
                ),
              ),
              Expanded(
                child: waitressController.isLoadingCreateWaitress
                    ? ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const WaitressCardShimmer();
                        },
                      )
                    : SmartRefresher(
                        controller: _controller,
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: () {
                          _onRefresh(waitressController);
                        },
                        onLoading: () {
                          _onLoading(waitressController);
                        },
                        child: ListView.builder(
                          itemCount: waitressController.waitressList.length,
                          itemBuilder: (context, index) {
                            final waitress =
                                waitressController.waitressList[index];
                            return WaitressCardComponent(
                              waitress: waitress,
                              onSelectedPopupMenuButton: (value) {
                                if (value == 'edit') {
                                  Get.toNamed(Routes.EDIT_WAITRESS, arguments: {
                                    'id': waitress.id,
                                    'name': waitress.name,
                                    'gender': waitress.gender,
                                  });
                                } else if (value == 'delete') {
                                  waitressController.deleteWaitress(
                                      context, waitress.id);
                                }
                              },
                            );
                          },
                        )),
              ),
              Container(
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

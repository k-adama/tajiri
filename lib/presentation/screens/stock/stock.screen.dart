import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/product_list_appro.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/product_list_appro_save.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/stock_card_title.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/component/stock_search_bar.component.dart';
import 'package:tajiri_pos_mobile/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer/product_appro.shimmer.dart';
import 'package:tajiri_pos_mobile/presentation/ui/shimmer_product_list.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final RefreshController _controller = RefreshController();
  final StockController stockController = Get.find();

  void _onRefresh() async {
    await stockController.fetchFoods();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await stockController.fetchFoods();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisserUi(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Inventaire",
                style:
                    Style.interNormal(size: 16.sp, color: Style.secondaryColor),
              ),
              iconTheme: const IconThemeData(color: Style.secondaryColor),
              backgroundColor: Style.white,
              leading: BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )),
        body: GetBuilder<StockController>(
          builder: (_stockController) => Container(
            color: Style.bgGrey, // change to Style.grey
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: stockController.checkboxstatus
                                ? const AssetImage(
                                    "assets/images/Carte appro 2.png")
                                : const AssetImage(
                                    "assets/images/Carte appro.png"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StockCardTitleComponent(
                              title: TrKeysConstant.ApproModeTitle,
                              description: TrKeysConstant.ApproModeDescription,
                              isTitle: true),
                          10.verticalSpace,
                          StockCardTitleComponent(
                              title: TrKeysConstant.SavApproModeTitle,
                              description:
                                  TrKeysConstant.SaveApproModeDescription,
                              isTitle: false),
                          8.verticalSpace,
                          CustomButton(
                              title: stockController.checkboxstatus
                                  ? TrKeysConstant.SaveAppro
                                  : TrKeysConstant.ApproMode,
                              background: stockController.checkboxstatus
                                  ? Style.white
                                  : Style.primaryColor,
                              radius: 3,
                              textColor: Style.secondaryColor,
                              isLoadingColor: Style.secondaryColor,
                              onPressed: () async {
                                if (stockController.checkboxstatus) {
                                  await _stockController.updateStock(context);
                                }

                                Future.delayed(Duration.zero, () {
                                  stockController.checkboxstatus =
                                      !stockController.checkboxstatus;
                                  stockController.update();
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                StockSearchBarComponent(
                    checkboxstatus: stockController.checkboxstatus ?? false),
                stockController.checkboxstatus
                    ? Expanded(
                        flex: 8,
                        child: _stockController.isProductLoading
                            ? const ShimmerProductListUi()
                            : _stockController.foodsInventory.isEmpty
                                ? SvgPicture.asset(
                                    "assets/svgs/empty.svg",
                                    height: 300.h,
                                  )
                                : AnimationLimiter(
                                    child: SmartRefresher(
                                      controller: _controller,
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      onLoading: _onLoading,
                                      onRefresh: _onRefresh,
                                      child: ProductListApproSaveComponent(
                                        foods: _stockController.foodsInventory,
                                        updateQuantity: (int quantity,
                                                dynamic foodUpdate) =>
                                            _stockController.updateQuantity(
                                                quantity, foodUpdate),
                                      ),
                                    ),
                                  ),
                      )
                    : Expanded(
                        flex: 8,
                        child: _stockController.isProductLoading
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return const ProductApproShimmer();
                                },
                              )
                            : _stockController.foods.isEmpty
                                ? SvgPicture.asset(
                                    "assets/svgs/empty.svg",
                                    height: 300.h,
                                  )
                                : AnimationLimiter(
                                    child: SmartRefresher(
                                      controller: _controller,
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      onLoading: _onLoading,
                                      onRefresh: _onRefresh,
                                      child: ProductListApproComponent(
                                          foods: _stockController.foods),
                                    ),
                                  ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

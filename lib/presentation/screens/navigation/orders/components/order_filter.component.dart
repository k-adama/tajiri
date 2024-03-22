import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/orders/order.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_tab_bar.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/custom_date_picker.widget.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/modal/drag.modal.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/modal/wrap.modal.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/title.widget.dart';

class OrderFilterComponent extends StatefulWidget {
  final bool isTabBar;
  final ValueChanged<List<DateTime?>> onChangeDay;

  const OrderFilterComponent(
      {Key? key, this.isTabBar = true, required this.onChangeDay})
      : super(key: key);

  @override
  State<OrderFilterComponent> createState() => _OrderFilterComponentState();
}

class _OrderFilterComponentState extends State<OrderFilterComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DateTime?> _rangeDatePicker = [DateTime.now(), DateTime.now()];
  final OrdersController ordersController = Get.find();

  final _tabs = [
    const Tab(child: Text("Jour")),
    const Tab(
      child: Text(
        "Semaine",
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ),
    const Tab(
      child: Text(
        "Mois",
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
      () {
        switch (_tabController.index) {
          case 0:
            _rangeDatePicker = [
              DateTime.now(),
              DateTime.now(),
            ];
            break;
          case 1:
            _rangeDatePicker = [
              DateTime.now().subtract(const Duration(days: 7)),
              DateTime.now(),
            ];
            break;
          case 2:
            _rangeDatePicker = [
              DateTime.now().subtract(const Duration(days: 30)),
              DateTime.now(),
            ];
            break;
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WrapModal(
      body: Container(
        height: screenSize.height - 150.h,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragModal(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TitleAndIconWidget(title: "Filtrer"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  "Selectionner la période",
                  style: Style.interNormal(
                    size: 14.sp,
                    color: Style.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              widget.isTabBar
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 24.h),
                      child: CustomTabBarUi(
                        tabController: _tabController,
                        tabs: _tabs,
                      ),
                    )
                  : const SizedBox.shrink(),
              CustomDatePickerWidget(
                  range: _rangeDatePicker,
                  onValuesChanged: (List<DateTime?> values) {
                    setState(() {
                      _rangeDatePicker = values;
                    });
                  }),
              16.verticalSpace,
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  title: "Enregistrer",
                  background: Style.secondaryColor,
                  isLoadingColor: Style.secondaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    ordersController.setRangeDate(
                        _rangeDatePicker.first!, _rangeDatePicker.last!);
                    widget.onChangeDay(_rangeDatePicker);
                  },
                ),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

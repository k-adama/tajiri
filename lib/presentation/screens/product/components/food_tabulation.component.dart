import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/tab_view.component.dart';

class EditFoodTabulation extends StatefulWidget {
  final Widget editFoodComponent;
  final Widget foodVariantAddedListComponent;
  const EditFoodTabulation({
    super.key,
    required this.editFoodComponent,
    required this.foodVariantAddedListComponent,
  });

  @override
  State<EditFoodTabulation> createState() =>
      _EditFoodTabulationComponentState();
}

class _EditFoodTabulationComponentState extends State<EditFoodTabulation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: tabulation(
        context,
        (index) => setState(() {
          _tabController.index = index;
        }),
      ),
    );
  }

  Widget tabulation(BuildContext context, ChangeIndexFunction changeIndex) {
    return DefaultTabController(
      length: 2,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 40.h,
              alignment: Alignment.topLeft,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                controller: _tabController,
                indicatorSize: null,
                dividerHeight: 0,
                indicatorColor: Style.secondaryColor,
                labelColor: Style.secondaryColor,
                // labelPadding: EdgeInsets.only(right: 70.w),
                padding: EdgeInsets.only(left: 10.w),
                indicator: null,
                onTap: (index) async {
                  changeIndex(index);
                },
                unselectedLabelColor: Style.dark,
                unselectedLabelStyle: Style.interNormal(
                  size: 14.sp,
                ),
                labelStyle: Style.interNormal(
                  size: 14.sp,
                ).copyWith(fontWeight: FontWeight.w700),
                tabs: List.generate(
                  2,
                  (index) => Tab(
                    child: Text(
                      editFoodTab[index].text!,
                      // style: Style.interNormal(
                      //   size: 14.sp,
                      //   color: _tabController.index == index
                      //       ? Style.dark
                      //       : Style.dark,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 8,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    widget.editFoodComponent,
                    widget.foodVariantAddedListComponent,
                    /* EditFoodTabulationComponent(
                      foodData: foodData,
                    ),*/
                    /*  FoodVariantAddedList(
                      foodVariantCategory: foodData.foodVariantCategory!,
                    ),*/
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

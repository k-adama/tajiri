import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/orders_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_pos_mobile/presentation/screens/table/components/custom_table.component.dart';

class TablesBoardComponent extends StatefulWidget {
  const TablesBoardComponent({super.key});

  @override
  _TablesBoardComponentState createState() => _TablesBoardComponentState();
}

class _TablesBoardComponentState extends State<TablesBoardComponent> {
  final user = AppHelpersCommon.getUserInLocalStorage();
  final RefreshController _controller = RefreshController();
  void _onRefresh(TableController tableController) async {
    tableController.fetchTables();
    _controller.refreshCompleted();
  }

  void _onLoading(TableController tableController) async {
    tableController.fetchTables();
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
        builder: (tablesController) => Column(
              /* mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, */
              children: [
                if (tablesController.tableListData.isNotEmpty ||
                    !tablesController.isLoadingTable)
                  Expanded(
                    child: SmartRefresher(
                        controller: _controller,
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: () {
                          _onRefresh(tablesController);
                        },
                        onLoading: () {
                          _onLoading(tablesController);
                        },
                        child: ListView(
                          children: [
                            Wrap(
                              children: [
                                for (int i = 0;
                                    i < tablesController.tableListData.length;
                                    i++)
                                  Padding(
                                      padding: REdgeInsets.only(
                                          right: 12, bottom: 12, top: 16),
                                      child: Draggable<int>(
                                        data: i,
                                        feedback: CustomTableComponent(
                                          tableModel: TableModel(
                                              name: tablesController
                                                  .tableListData[i].name,
                                              persons: tablesController
                                                  .tableListData[i].persons,
                                              restaurantId: tablesController
                                                  .tableListData[i]
                                                  .restaurantId,
                                              id: tablesController
                                                  .tableListData[i].id,
                                              description: tablesController
                                                  .tableListData[i].description,
                                              imageUrl: tablesController
                                                  .tableListData[i].imageUrl),
                                          type: "available",
                                        ),
                                        childWhenDragging:
                                            const SizedBox.shrink(),
                                        child: GestureDetector(
                                          onTap: () {
                                            final tableModel = tablesController
                                                .tableListData[i];
                                            final String tableId =
                                                tableModel.id.toString();
                                            final String tableName =
                                                tableModel.name.toString();
                                            final String tableDescription =
                                                tableModel.description
                                                    .toString();
                                            final String persons =
                                                tableModel.persons.toString();
                                            Get.toNamed(
                                              Routes.EDIT_TABLE,
                                              arguments: {
                                                'name': tableName,
                                                'description': tableDescription,
                                                'persons': persons,
                                                'id': tableId,
                                              },
                                            );

                                            /*_copyToClipboard(
                                                "https://www.app-qrcode.tajiri.io/?restaurantId=${restaurantId}&tableId=${tableId}");*/
                                          },
                                          child: CustomTableComponent(
                                            tableModel: TableModel(
                                                name: tablesController
                                                    .tableListData[i].name,
                                                persons: tablesController
                                                    .tableListData[i].persons,
                                                restaurantId: tablesController
                                                    .tableListData[i]
                                                    .restaurantId,
                                                id: tablesController
                                                    .tableListData[i].id,
                                                description: tablesController
                                                    .tableListData[i]
                                                    .description,
                                                imageUrl: tablesController
                                                    .tableListData[i].imageUrl),
                                            type: "available",
                                          ),
                                        ),
                                      ))
                              ],
                            ),
                            if (tablesController.isLoadingTable)
                              const Center(
                                child: CircularProgressIndicator(
                                    color: Style.brandColor),
                              ),
                          ],
                        )),
                  ),
                if (tablesController.tableListData.isNotEmpty &&
                    tablesController.isLoadingTable)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Style.brandColor),
                    ),
                  ),
              ],
            ));
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Text copied to clipboard: $text'),
    ));
  }
}

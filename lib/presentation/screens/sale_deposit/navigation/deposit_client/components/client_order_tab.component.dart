import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_client/deposit_client.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/client_orders_item.component.dart';

class ClientOrdersTabComponent extends StatefulWidget {
  final TabController tabController;
  const ClientOrdersTabComponent({super.key, required this.tabController});

  @override
  State<ClientOrdersTabComponent> createState() =>
      _ClientOrdersTabComponentState();
}

class _ClientOrdersTabComponentState extends State<ClientOrdersTabComponent>
    with AutomaticKeepAliveClientMixin {
  List<String> orders = [];

  int currentPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final controller = Get.find<DepositClientController>();
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchMoreOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreOrders();
    }
  }

  // Récupérer plus de données (pagination)
  void _fetchMoreOrders() async {
    setState(() {
      isLoading = true;
    });

    currentPage++;
    List<String> newOrders =
        await controller.fetchOrdersFromApi(currentPage, _pageSize);
    setState(() {
      orders.addAll(newOrders);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener(
      onNotification: (notification) {
        final isOrder = widget.tabController.index == 0;
        print("object=====isOrder : $isOrder=========");
        if (notification is ScrollEndNotification && isOrder) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            _fetchMoreOrders();
            return true;
          }
        }
        return true;
      },
      child: ListView.builder(
        itemCount: orders.length + 1,
        itemBuilder: (context, index) {
          if (index < orders.length) {
            return const ClientOrdersItemComponent();
          } else if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

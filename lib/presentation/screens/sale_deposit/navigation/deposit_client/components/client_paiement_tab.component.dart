import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sale_deposit/deposit_navigation/deposit_client/deposit_client.controller.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/client_orders_item.component.dart';

class ClientPaiementTabComponent extends StatefulWidget {
  final TabController tabController;

  const ClientPaiementTabComponent({super.key, required this.tabController});

  @override
  State<ClientPaiementTabComponent> createState() =>
      _ClientPaiementTabComponentState();
}

class _ClientPaiementTabComponentState extends State<ClientPaiementTabComponent>
    with AutomaticKeepAliveClientMixin {
  List<String> paiements = [];

  int currentPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final controller = Get.find<DepositClientController>();
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchMorePaiements();
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
      _fetchMorePaiements();
    }
  }

  // Récupérer plus de données (pagination)
  void _fetchMorePaiements() async {
    setState(() {
      isLoading = true;
    });

    currentPage++;
    List<String> newpaiements =
        await controller.fetchOrdersFromApi(currentPage, _pageSize);
    setState(() {
      paiements.addAll(newpaiements);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener(
      onNotification: (notification) {
        final isPaiement = widget.tabController.index == 1;
        print("object=====isPaiement : $isPaiement=========");
        if (notification is ScrollEndNotification && isPaiement) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            _fetchMorePaiements();
            return true;
          }
        }
        return true;
      },
      child: ListView.builder(
        itemCount: paiements.length + 1,
        itemBuilder: (context, index) {
          if (index < paiements.length) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Style.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const OrderInfoHeaderComponent(
                orderStatus: "Cash",
              ),
            );
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

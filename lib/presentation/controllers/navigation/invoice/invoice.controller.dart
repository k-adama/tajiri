import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf_invoice.service.dart';
import 'package:tajiri_pos_mobile/app/services/app_connectivity.service.dart';
import 'package:tajiri_pos_mobile/domain/entities/printer_model.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class InvoiceController extends GetxController {
  final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final bluetoothController =
      Get.find<NavigationController>().bluetoothController;

  //
  final tableList = List<Table>.empty().obs;
  final waitressList = List<Waitress>.empty().obs;
  final customersList = List<Customer>.empty().obs;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() {
    Future.wait([
      fetchCustomers(),
      fetchWaitress(),
      fetchTables(),
    ]);
    super.onReady();
  }

  void shareFacture(Order order) async {
    Mixpanel.instance.track("Share Ticket to customer", properties: {
      "Order Status": order.status,
      "Customer type": order.customerType,
      "Total Price": order.grandTotal,
      "Payment method": order.payments.isNotEmpty
          ? getNamePaiementById(order.payments[0].paymentMethodId)
          : ""
    });

    final customer = customerName(order);
    final waitressName = tableOrWaitressName(order);

    final pdfFile = await ApiPdfInvoiceService.generate(
      order,
      customer,
      waitressName,
    );

    ApiPdfService.shareFile(pdfFile);
  }

  void printButtonTap(Order order) {
    if (bluetoothController.isLoading.value) {
      return;
    }
    if (bluetoothController.connected.value == false) {
      Get.toNamed(Routes.SETTING_BLUETOOTH);
    } else {
      final printerModel = order.toPrinterModelEntity(
        user?.lastname,
        restaurant?.name,
        restaurant?.phone,
      );
      bluetoothController.printReceipt(printerModel);
    }
  }

  String tableOrWaitressName(Order order) {
    if (order.waitressId != null) {
      return getNameWaitressById(order.waitressId, waitressList);
    } else if (order.tableId != null) {
      return getNameTableById(order.tableId, tableList);
    } else {
      return "";
    }
  }

  String customerName(Order order) {
    return order.customerType == "SAVED"
        ? getNameCustomerById(order.customerId, customersList)
        : "Client de passage";
  }

  Future<void> fetchCustomers() async {
    if (restaurantId == null) {
      print("===restaurantId null");
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final result =
            await tajiriSdk.customersService.getCustomers(restaurantId!);
        customersList.assignAll(result);
        update();
      } catch (e) {
        print("======Error fetch Custommer : $e");
        update();
      }
    }
  }

  Future<void> fetchWaitress() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final result = await tajiriSdk.waitressesService.getWaitresses();
        waitressList.assignAll(result);
        update();
      } catch (e) {
        print("======Error fetch Waitress : $e");
        update();
      }
    }
  }

  Future<void> fetchTables() async {
    if (restaurantId == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId!);
        tableList.assignAll(result);
        update();
      } catch (e) {
        update();
      }
    }
  }
}

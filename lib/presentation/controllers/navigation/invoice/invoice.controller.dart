import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/common/app_helpers.common.dart';
import 'package:tajiri_pos_mobile/app/config/constants/app.constant.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf.service.dart';
import 'package:tajiri_pos_mobile/app/services/api_pdf_invoice.service.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class InvoiceController extends GetxController {
  final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  void shareFacture(Order order) async {
    Mixpanel.instance.track("Share Ticket to customer", properties: {
      "Order Status": order.status,
      "Customer type": order.customerType,
      "Total Price": order.grandTotal,
      "Payment method": order.payments.isNotEmpty
          ? getNamePaiementById(order.payments[0].paymentMethodId)
          : ""
    });

    final pdfFile = await ApiPdfInvoiceService.generate(order);

    ApiPdfService.shareFile(pdfFile);
  }
}

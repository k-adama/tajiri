import 'package:get/route_manager.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/auth/auth.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/bluetooth_setting/bluetooth_setting.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/sales_reports/sales_reports.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/invoice/invoice.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/table/table.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/product/product.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/tutoriel/tutoriel.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/waitress/waitress.binding.dart';
import 'package:tajiri_pos_mobile/presentation/screens/auth/demo_login.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/auth/login.screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/demo/demo.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.binding.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/splash/splash.binding.dart';
import 'package:tajiri_pos_mobile/presentation/screens/bluetooth_setting/bluetooth_setting.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/demo/demo.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/invoice/invoice.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/navigation.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/cart_paid.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/components/date_time_picker.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sales_reports/sales_reports.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/pos/cart/cart_save.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/components/edit_food_component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/product/product.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/splash/splash.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/stock/stock.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/table/edit_table.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/table/table.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/tutoriel/tutoriel.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/edit_waitress.screen.dart';
import 'package:tajiri_pos_mobile/presentation/screens/waitress/waitress.screen.dart';

part 'presentation_path.route.dart';

class PresentationScreenRoute {
  PresentationScreenRoute._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.DEMO_APP,
      page: () => const DemoAppScreen(),
      binding: DemoAppBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => const NavigationScreen(),
      binding: NavigationBiding(),
    ),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginScreen(),
        binding: AuthBinding()),
    GetPage(
        name: _Paths.DEMO_LOGIN,
        page: () => DemoLoginView(),
        binding: AuthBinding()),
    GetPage(
      name: _Paths.TUTORIELS,
      page: () => const TutorielScreen(),
      binding: TutorielsBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT_DATE_TIME_PICKER,
      page: () => const SalesReportsDateTimePickerComponent(),
      binding: SalesReportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT,
      page: () => const SalesReportsScreen(),
      binding: SalesReportBinding(),
    ),
    GetPage(
      name: _Paths.CART_SAVE,
      page: () => const CartSaveScreen(),
    ),
    GetPage(
      name: _Paths.CART_PAID,
      page: () => const CartPaidScreen(),
    ),
    GetPage(
      name: _Paths.INVOICE,
      page: () => const InvoiceScreen(),
      binding: InvoiceBiding(),
    ),
    GetPage(
      name: _Paths.STOCK,
      page: () => const StockScreen(),
      binding: StockBinding(),
    ),
    GetPage(
      name: _Paths.TABLE,
      page: () => const TableScreen(),
      binding: TableBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_TABLE,
      page: () => const EditTableScreen(),
    ),
    GetPage(
      name: _Paths.WAITRESS,
      page: () => const WaitressScreen(),
      binding: WaitressBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_BLUETOOTH,
      page: () => const BluetoothSettingScreen(),
      binding: BluetoothSettingBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_WAITRESS,
      page: () => const EditWaitressScreen(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => const ProductScreen(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_FOOD_AND_VARIANT,
      page: () => const EditFoodAndVariantComponent(),
      binding: ProductsBinding(),
    ),
  ];
}

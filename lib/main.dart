import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/config/env/environment.env.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/mixpanel/mixpanel.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:tajiri_pos_mobile/presentation/routes/presentation_screen.route.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/splash/splash.binding.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/custom_range_slider.widget.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseToken,
  );
    TajiriSDK.initialize(env: EnvType.production, debugEnable: false);
  try {
    await Mixpanel.init(Environment.mixpanelToken, trackAutomaticEvents: true);
  } catch (e) {
    print("Mixpanel error : $e");
  }

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Environment.onesignalToken);
  OneSignal.Notifications.requestPermission(true);

  await Mixpanel.init(Environment.mixpanelToken, trackAutomaticEvents: true);

  await Upgrader.clearSavedSettings();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Style.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(
    FutureBuilder(
      future: Future.wait([
        LocalStorageService.getInstance(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return RefreshConfiguration(
                footerBuilder: () => const ClassicFooter(
                  idleIcon: SizedBox(),
                  idleText: "",
                  noDataText: "",
                ),
                headerBuilder: () => const WaterDropMaterialHeader(
                  backgroundColor: Style.white,
                  color: Style.textGrey,
                ),
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: "Tajiri",
                  initialBinding: SplashBinding(),
                  initialRoute: PresentationScreenRoute.INITIAL,
                  getPages: PresentationScreenRoute.routes,
                  localizationsDelegates: const [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('fr', 'FR'),
                  ],
                  locale: const Locale('fr'),
                  theme: ThemeData(
                    fontFamily: 'Cereal',
                    useMaterial3: false,
                    sliderTheme: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                      rangeThumbShape: CustomRoundRangeSliderThumbShapeWidget(
                        enabledThumbRadius: 12.r,
                      ),
                    ),
                  ),
                  themeMode: ThemeMode.light,
                ),
              );
            });
      },
    ),
  );
}

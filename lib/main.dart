import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/app/services/local_storage.service.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/navigation.binding.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/navigation.screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FutureBuilder(
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
                initialBinding: NavigationBiding(),
                localizationsDelegates: const [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('fr', 'FR'),
                ],
                locale: const Locale('fr'),
                home: NavigationScreen(),
                theme: ThemeData(
                  fontFamily: 'Cereal',
                  useMaterial3: false,
                  /*sliderTheme: SliderThemeData(
                    overlayShape: SliderComponentShape.noOverlay,
                    rangeThumbShape: CustomRoundRangeSliderThumbShape(
                      enabledThumbRadius: 12.r,
                    ),
                  ),*/
                ),
                themeMode: ThemeMode.light,
              ),
            );
          });
    },
  ));
}

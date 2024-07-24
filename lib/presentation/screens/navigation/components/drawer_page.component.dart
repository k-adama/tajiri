import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_page_body.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_page_footer.component.dart';
import 'package:tajiri_pos_mobile/presentation/screens/navigation/components/drawer_page_header.component.dart';

class DrawerPageComponent extends StatelessWidget {
  const DrawerPageComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Style.secondaryColor,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: Style.black, width: 1.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: DrawerPageHearderComponent(),
            )),
        const DrawerPageBodyComponent(),
         DrawerPageFooterComponent(),
      ],
    );
  }
}

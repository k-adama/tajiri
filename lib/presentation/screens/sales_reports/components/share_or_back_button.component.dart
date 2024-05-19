import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/buttons/custom_secondary.button.dart';

class SalesReportsShareOrBackButton extends StatelessWidget {
  final VoidCallback onTapShare;
  final VoidCallback onTapBack;
  const SalesReportsShareOrBackButton({
    super.key,
    required this.onTapShare,
    required this.onTapBack,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomButton(
                      title: 'Partager le rapport',
                      textColor: Style.secondaryColor,
                      weight: 20,
                      background: Style.primaryColor,
                      radius: 3,
                      onPressed: onTapShare,
                    ),
                    CustomSecondaryButton(
                        title: 'Retour à la génération du rapport',
                        titleColor: Style.secondaryColor,
                        onPressed: onTapBack),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

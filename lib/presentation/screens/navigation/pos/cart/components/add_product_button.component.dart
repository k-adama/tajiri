import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class AddProductButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  const AddProductButtonComponent({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 30,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                  color: Style.yellowLigther,
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Style.titleDark,
                )),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: Style.primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Ajouter produit",
                    style: Style.interNormal(size: 12, color: Style.titleDark),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

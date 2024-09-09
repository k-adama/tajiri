import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/main.dart';

class OrganisationChoiceRadioComponent extends StatelessWidget {
  final Organisation organisation;
  final String? selectedId;
  final void Function(String?)? onChanged;

  const OrganisationChoiceRadioComponent({
    super.key,
    required this.organisation,
    required this.selectedId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelect = organisation.id == selectedId;
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(organisation.id);
        }
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: tajiriDesignSystem.appBorderRadius.sm,
            border: Border.all(
                color: isSelect
                    ? tajiriDesignSystem.appColors.mainBlue500
                    : Colors.transparent,
                width: 2)),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    right: organisation.id == selectedId ? 5 : 6),
                child: Text(
                  organisation.name,
                  style: organisation.id == selectedId
                      ? Style.interBold(size: 12)
                      : Style.interNormal(size: 12),
                ),
              ),
            ),
            11.horizontalSpace,
            Container(
              height: 30,
              width: 30,
              child: Radio<String?>(
                value: organisation.id,
                groupValue: selectedId,
                onChanged: onChanged,
                activeColor: tajiriDesignSystem.appColors.mainBlue500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Organisation {
  final String id;
  final String name;

  Organisation({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Méthode pour créer une instance d'Organisation à partir d'un Map (utile pour le décodage JSON)
  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      id: json['id'],
      name: json['name'],
    );
  }

  static final fakeData = [
    Organisation(
      id: '1',
      name: 'Small Business',
    ),
    Organisation(
      id: '2',
      name: 'Grand Business',
    ),
    Organisation(
      id: '3',
      name: 'Grand Compte',
    ),
  ];
}

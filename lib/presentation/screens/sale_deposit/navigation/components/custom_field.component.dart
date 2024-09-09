import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/border.text_field.dart';

class CustomFieldWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final bool? isDescription;
  final TextInputType keyboardType;

  const CustomFieldWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.isDescription,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold), // Remplace par Style.interBold()
          ),
        ),
        const SizedBox(height: 8), // Remplace 8.verticalSpace
        BorderTextField(
          hintText: hintText,
          height: isDescription == true ? null : 45,
          isDescription: isDescription,
          keyboardType: keyboardType,
          prefixIcon: prefixIcon,
          backgroundColor: Colors.transparent,
          controller: controller,
        ),
      ],
    );
  }
}

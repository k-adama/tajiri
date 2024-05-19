import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/search_bar.text_field.dart';

class SearchCustomerComponent extends StatefulWidget {
  const SearchCustomerComponent({super.key});

  @override
  State<SearchCustomerComponent> createState() =>
      _SearchCustomerComponentState();
}

class _SearchCustomerComponentState extends State<SearchCustomerComponent> {
  final TextEditingController search = TextEditingController();

  final TextEditingController searchController = TextEditingController();
  bool isSearchFocused = false;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(builder: (posController) {
      return SearchBarTextField(
        searchController: searchController,
        hintText: "Rechercher un client ...",
        focusNode: searchFocusNode,
        onSearch: (text) => posController.searchClient(text),
        color: null,
      );
    });
  }
}

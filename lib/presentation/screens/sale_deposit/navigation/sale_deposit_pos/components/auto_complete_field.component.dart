import 'package:flutter/material.dart';

class AutoCompleteFormField<T extends Object> extends StatefulWidget {
  final List<T> options;
  final List<T> excludedItems;
  final double width;
  final bool isMultipleSelect;
  final bool showAllOptionsWhenEmpty;
  final double? optionHeigth;
  final String hintText;
  final String Function(T) displayStringForOption;
  final Widget Function(T)? displayWidgetForOption;

  final void Function(T) onSelected;
  final T? initialValue;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const AutoCompleteFormField({
    super.key,
    required this.options,
    required this.excludedItems,
    required this.displayStringForOption,
    this.displayWidgetForOption,
    required this.onSelected,
    required this.width,
    this.hintText = "Acompagnement",
    this.optionHeigth = 200,
    this.isMultipleSelect = true,
    this.initialValue,
    this.showAllOptionsWhenEmpty = true,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<AutoCompleteFormField> createState() =>
      _AutoCompleteFormFieldState<T>();
}

class _AutoCompleteFormFieldState<T extends Object>
    extends State<AutoCompleteFormField<T>> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  bool showCreateButton = false;

  void _onTextChanged(TextEditingValue textEditingValue) {
    setState(() {
      final text = textEditingValue.text.toLowerCase().trim();
      showCreateButton = !widget.options.any((option) =>
          widget.displayStringForOption(option).toLowerCase().startsWith(text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Autocomplete<T>(
        initialValue: TextEditingValue(
          text: widget.initialValue != null
              ? widget.displayStringForOption(widget.initialValue!)
              : '',
        ),
        optionsBuilder: (TextEditingValue textEditingValue) {
          _onTextChanged(textEditingValue);
          final filteredOptions = widget.options
              .where((option) => !widget.excludedItems.contains(
                  option)) // Exclure les éléments déjà dans bundleProductEntity
              .where((option) {
            return widget
                .displayStringForOption(option)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          }).toList();
          if (textEditingValue.text == '') {
            return widget.showAllOptionsWhenEmpty
                ? filteredOptions
                : Iterable<T>.empty();
          }
          return filteredOptions;
        },
        // optionsMaxHeight: 100,
        displayStringForOption: widget.displayStringForOption,
        onSelected: widget.onSelected,
        optionsViewOpenDirection: OptionsViewOpenDirection.down,
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController controller,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          textEditingController = controller;
          this.focusNode = focusNode;
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: showCreateButton ? widget.suffixIcon : null,
            ),
          );
        },
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<T> onSelected,
          Iterable<T> options,
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 10,
              child: Container(
                width: widget.width, // MediaQuery.of(context).size.width * 0.8,
                height: widget.optionHeigth,
                color: Colors.white,
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final T option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                          if (widget.isMultipleSelect) {
                            textEditingController.clear();
                          } else {
                            focusNode.unfocus();
                          }
                        },
                        child: widget.displayWidgetForOption != null
                            ? widget.displayWidgetForOption!(option)
                            : Text(widget.displayStringForOption(option)),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// DropdownButtonHideUnderline(
//                             child: DropdownButton2<String>(
//                               isExpanded: true,

//                               hint: Text(
//                                 'Sélectionner un client',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Theme.of(context).hintColor,
//                                 ),
//                               ),
//                               items: items
//                                   .map((item) => DropdownMenuItem(
//                                         value: item,
//                                         child: Text(
//                                           "item",
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ))
//                                   .toList(),
//                               value: selectedValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedValue = value;
//                                 });
//                               },
//                               buttonStyleData: ButtonStyleData(
//                                   padding: EdgeInsets.symmetric(horizontal: 16),
//                                   height: 40,
//                                   width: 200,
//                                   decoration: BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.circular(20),
//                                   )),
//                               dropdownStyleData: DropdownStyleData(
//                                 maxHeight: 200,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),

//                               dropdownSearchData: DropdownSearchData(
//                                 searchController: textEditingController,
//                                 searchInnerWidgetHeight: 50,
//                                 searchInnerWidget: Container(
//                                   height: 50,
//                                   padding: const EdgeInsets.only(
//                                     top: 8,
//                                     bottom: 4,
//                                     right: 8,
//                                     left: 8,
//                                   ),
//                                   child: TextFormField(
//                                     expands: true,
//                                     maxLines: null,
//                                     controller: textEditingController,
//                                     decoration: InputDecoration(
//                                       isDense: true,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 8,
//                                       ),
//                                       hintText: 'Search for an item...',
//                                       hintStyle: const TextStyle(fontSize: 12),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 searchMatchFn: (item, searchValue) {
//                                   return item.value
//                                       .toString()
//                                       .contains(searchValue);
//                                 },
//                               ),
//                               //This to clear the search value when you close the menu
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   textEditingController.clear();
//                                 }
//                               },
//                             ),
//                           )
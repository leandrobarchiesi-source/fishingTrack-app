import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class AutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<String> availableValues;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSelected;

const AutocompleteField({
      super.key,
    required this.controller,
    this.focusNode,
    required this.availableValues,
    required this.onChanged,
    required this.onSelected,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Autocomplete<String>(
        initialValue: TextEditingValue(
          text: controller.text,
        ),
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return availableValues;
          }

          return availableValues.where(
            (s) => s.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
          );
        },
        onSelected: onSelected,
        fieldViewBuilder: (
          context,
          textController,
          node,
          onFieldSubmitted,
        ) {
          textController.text = controller.text;

          return TextField(
            controller: textController,
            focusNode: focusNode ?? node,
            decoration: InputDecoration(
            hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              controller.text = value;
              onChanged(value);
            },
          );
        },
      ),
    );
  }
}
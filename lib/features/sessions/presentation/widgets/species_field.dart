import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class SpeciesField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<String> availableSpecies;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSelected;

  const SpeciesField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.availableSpecies,
    required this.onChanged,
    required this.onSelected,
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
            return availableSpecies;
          }

          return availableSpecies.where(
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
              hintText: T.species,
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
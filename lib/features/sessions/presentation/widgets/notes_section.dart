import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class NotesSection extends StatelessWidget {
  final TextEditingController controller;

  const NotesSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: T.notes,
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
      ),
    );
  }
}
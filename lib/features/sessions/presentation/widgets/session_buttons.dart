import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class SessionButtons extends StatelessWidget {
  final bool loading;
  final bool isNewSession;
  final VoidCallback onSave;

  const SessionButtons({
    super.key,
    required this.loading,
    required this.isNewSession,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
onPressed: loading
    ? null
    : () {
        debugPrint("SESSION BUTTON PRESSED");
        onSave();
      },
              style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          isNewSession
              ? T.saveSession
              : T.saveChanges,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
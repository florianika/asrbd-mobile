import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String title = 'Confirmation',
  String content = 'Are you sure you want to proceed?',
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}

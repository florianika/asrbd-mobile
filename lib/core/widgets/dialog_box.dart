import 'package:flutter/material.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? cancelText,
  String? confirmText,
}) async {
  final localizations = AppLocalizations.of(context);
  final dialogTitle = title ?? localizations.translate(Keys.confirmationTitle);
  final dialogContent = content ?? localizations.translate(Keys.confirmationContent);
  final dialogCancelText = cancelText ?? localizations.translate(Keys.cancel);
  final dialogConfirmText = confirmText ?? localizations.translate(Keys.confirmationConfirm);
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(dialogTitle),
      content: Text(dialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(dialogCancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(dialogConfirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}

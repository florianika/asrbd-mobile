import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter/material.dart';

class NotifierService {
  static void showMessage(
    BuildContext context, {
    String? messageKey,
    String? message,
    required MessageType type,
  }) {
    assert(
      messageKey != null || message != null,
      'Either messageKey or message must be provided.',
    );

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Hide existing snackbars or banners
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.hideCurrentMaterialBanner();

    final String content = messageKey != null
        ? AppLocalizations.of(context).translate(messageKey)
        : message!;

    if (type == MessageType.error) {
      scaffoldMessenger.showMaterialBanner(
        MaterialBanner(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade800, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade50,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 3,
          shadowColor: Colors.red.shade200,
          actions: [
            TextButton(
              onPressed: () {
                scaffoldMessenger.hideCurrentMaterialBanner();
              },
              child: Text(
                AppLocalizations.of(context).translate(Keys.dismiss),
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          leadingPadding: const EdgeInsets.only(left: 8),
        ),
      );
    } else {
      final Color backgroundColor;
      final IconData icon;
      switch (type) {
        case MessageType.success:
          backgroundColor = Colors.green.shade600;
          icon = Icons.check_circle;
          break;
        case MessageType.warning:
          backgroundColor = Colors.orange.shade700;
          icon = Icons.warning_amber_rounded;
          break;
        case MessageType.info:
        default:
          backgroundColor = Colors.blue.shade600;
          icon = Icons.info_outline;
          break;
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final String heroTag;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isVisible;
  final String? tooltip;
  const FloatingButton({
    super.key,
    required this.icon,
    required this.heroTag,
    this.onPressed,
    required this.isEnabled,
    this.isVisible = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: tooltip ?? '',
      child: FloatingActionButton(
        heroTag: heroTag,
        mini: true,
        backgroundColor: Colors.white,
        foregroundColor: isEnabled ? Colors.black : Colors.grey,
        onPressed: isEnabled ? onPressed : null,
        child: Icon(icon),
      ),
    );
  }
}

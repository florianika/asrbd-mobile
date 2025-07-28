import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final String heroTag;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isVisible;
  const FloatingButton({
    super.key,
    required this.icon,
    required this.heroTag,
    this.onPressed,
    required this.isEnabled,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: isEnabled ? Colors.black : Colors.grey,
      onPressed: isEnabled ? onPressed : null,
      child: Icon(icon),
    );
  }
}

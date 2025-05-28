import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final String heroTag;
  final VoidCallback? onPressed;
  final bool isEnabled;
  const FloatingButton({
    super.key,
    required this.icon,
    required this.heroTag,
    this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: isEnabled ? Colors.black : Colors.grey,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}

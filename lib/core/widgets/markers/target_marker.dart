import 'package:flutter/material.dart';

class TargetMarker extends StatelessWidget {
  final Color? color;
  const TargetMarker({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
        border:
            Border.all(color: color == null ? Colors.green : color!, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 18,
              height: 1,
              color: color == null ? Colors.green : color!),
          Container(
              width: 1,
              height: 18,
              color: color == null ? Colors.green : color!),
        ],
      ),
    );
  }
}

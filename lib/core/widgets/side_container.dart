import 'package:flutter/material.dart';

class SideContainer extends StatefulWidget {
  final Widget child;
  const SideContainer({super.key, required this.child});

  @override
  State<SideContainer> createState() => _SideContainerState();
}

class _SideContainerState extends State<SideContainer> {
  double _sidePanelFractionDefualt = 0.4;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          setState(() {
            _sidePanelFractionDefualt -=
                details.delta.dx / MediaQuery.of(context).size.width;
            _sidePanelFractionDefualt =
                _sidePanelFractionDefualt.clamp(0.4, 0.9);
          });
        },
        onDoubleTap: () {
          setState(() {
            _sidePanelFractionDefualt = 0.4;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: Container(
            width: 8,
            color: Colors.grey.shade300,
            child: Center(
              child: Container(
                width: 10,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * _sidePanelFractionDefualt,
        child: widget.child,
      ),
    ]);
  }
}

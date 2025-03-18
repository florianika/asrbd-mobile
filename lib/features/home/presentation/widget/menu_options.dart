import 'package:asrdb/core/enums/map_on_tap_type.dart';
import 'package:flutter/material.dart';

class MenuOptions extends StatefulWidget {
  final Function handleOnTap;
  final bool isDrawing;
  const MenuOptions(
      {super.key, required this.handleOnTap, required this.isDrawing});

  @override
  State<MenuOptions> createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        !widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.domain_add),
                onPressed: () =>
                    widget.handleOnTap(null, OnTapType.addBuilding),
              )
            : const SizedBox(),
        const SizedBox(height: 10), //
        !widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.meeting_room),
                onPressed: () =>
                    widget.handleOnTap(null, OnTapType.addEntrance),
              )
            : const SizedBox(),
        const SizedBox(height: 10), // Space between buttons
        widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.undo),
                onPressed: () => widget.handleOnTap(null, OnTapType.undo),
              )
            : const SizedBox(),
        widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.redo),
                onPressed: () => widget.handleOnTap(null, OnTapType.redo),
              )
            : const SizedBox(),
        const SizedBox(height: 10), // Space between buttons
        widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.close),
                onPressed: () => widget.handleOnTap(null, OnTapType.delete),
              )
            : const SizedBox(),
        widget.isDrawing
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.save),
                onPressed: () => widget.handleOnTap(null, OnTapType.save),
              )
            : const SizedBox(),
      ],
    );
  }
}

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:asrdb/core/enums/map_on_tap_type.dart';
import 'package:asrdb/features/home/presentation/widget/menu_options.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:asrdb/core/widgets/side_menu.dart';

class HomeMobile extends StatefulWidget {
  final ArcGISMapViewController mapViewController;
  final Function onMapViewReady;
  final Feature? itemData;
  final bool showInfo;
  final Function onTapHandler;
  final bool? isDrawing;

  const HomeMobile({
    super.key,
    required this.mapViewController,
    required this.onMapViewReady,
    required this.showInfo,
    required this.onTapHandler,
    this.itemData,
    this.isDrawing,
  });

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  void _showCustomModal(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9, // Max 90% height
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: DraggableScrollableSheet(
            initialChildSize: 0.6, // Start at 60% of the screen
            minChildSize: 0.3, // Collapse to 30%
            maxChildSize: 0.9, // Expand to 90%
            expand: false, // Prevents taking full height
            builder: (context, scrollController) {
              return ListView(
                children: widget.itemData!.attributes.entries.map((entry) {
                  // Each entry contains a key and a value
                  return ListTile(
                    title: Text('${entry.key} - ${entry.value}'),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }

  void handleOnTap(Offset? offset, OnTapType tapType) {
    widget.onTapHandler(offset, tapType);
    if (tapType == OnTapType.featureSelected) {
      if (widget.itemData != null) _showCustomModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Example'),
      ),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          // ArcGIS Map as the base layer
          ArcGISMapView(
            controllerProvider: () => widget.mapViewController,
            onMapViewReady: () => widget.onMapViewReady(),
            onTap: (Offset offset) =>
                handleOnTap(offset, OnTapType.featureSelected),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: MenuOptions(
                handleOnTap: widget.onTapHandler,
                isDrawing: widget.isDrawing == null ? false : widget.isDrawing!,
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

class HomeTablet extends StatefulWidget {
  final ArcGISMapViewController mapViewController;
  final Function onMapViewReady;
  final Feature? itemData;
  final bool showInfo;
  final Function onTapHandler;
  const HomeTablet({
    super.key,
    required this.mapViewController,
    required this.onMapViewReady,
    required this.showInfo,
    required this.onTapHandler,
    this.itemData,
  });

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  void handleOnTap(Offset offset) {
    widget.onTapHandler(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Example'),
      ),
      drawer: const SideMenu(),
      body: Row(children: <Widget>[
        // First column taking 70% of the width
        Flexible(
          flex: 6,
          child: ArcGISMapView(
            controllerProvider: () => widget.mapViewController,
            onMapViewReady: () => widget.onMapViewReady(),
            onTap: (Offset offset) => handleOnTap(offset),
          ),
        ),

        // Second column taking the remaining space (30%)
        Flexible(
          flex: 4, // 30% width
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: widget.itemData != null
                ? ListView(
                    children: widget.itemData!.attributes.entries.map((entry) {
                      // Each entry contains a key and a value
                      return ListTile(
                        title: Text('${entry.key} - ${entry.value}'),
                      );
                    }).toList(),
                  )
                : Container(),
          ),
        ),
      ]),
    );
  }
}

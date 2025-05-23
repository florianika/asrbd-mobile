import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingMarker extends StatelessWidget {
  final Map<String, dynamic>? buildingsData;
  final int? selectedObjectId;
  final ShapeType? selectedShapeType;
   final void Function(
    BuildContext context,
    Offset globalPosition,
    EntityType type,
    LatLng position,
  ) onLongPressContextMenu;
  const BuildingMarker({
    super.key,
    this.buildingsData,
    this.selectedObjectId,
    this.selectedShapeType,
     required this.onLongPressContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    if (buildingsData == null) return const SizedBox();

    final features =
        List<Map<String, dynamic>>.from(buildingsData!['features']);

    return Stack(
      children: [
        PolygonLayer(
          polygons: features.map((feature) {
            final props = feature['properties'] as Map<String, dynamic>;
            final value = props['BldQuality'];

            Color fillColor;
            if (selectedShapeType == ShapeType.polygon &&
                selectedObjectId == props['OBJECTID']) {
              fillColor = Colors.red;
            } else if (value == 1) {
              fillColor = Colors.blue.withOpacity(0.7);
            } else if (value == 2) {
              fillColor = Colors.purple.withOpacity(0.7);
            } else if (value == 3) {
              fillColor = Colors.brown.withOpacity(0.7);
            } else if (value == 4) {
              fillColor = Colors.teal.withOpacity(0.7);
            } else {
              fillColor =
                  const Color.fromARGB(255, 60, 145, 214).withOpacity(0.7);
            }

            return Polygon(
              points: GeometryHelper.parseCoordinates(feature['geometry']),
              color: fillColor,
              borderStrokeWidth: 1.0,
            );
          }).toList(),
        ),
        // MarkerLayer(
        //   markers: features.map((feature) {
        //     final polygonPoints =
        //         GeometryHelper.parseCoordinates(feature['geometry']);
        //     final center = GeometryHelper.getPolygonCentroid(polygonPoints);

        //     return Marker(
        //       point: center,
        //       width: 100,
        //       height: 100,
        //       child: GestureDetector(
        //         onLongPressStart: (details) {
        //           onLongPressContextMenu(
        //             context,
        //             details.globalPosition,
        //             EntityType.building,
        //             center,
        //           );
        //         },
        //         child: Container(
        //           color: Colors.black,
        //         ),
        //       ),
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}

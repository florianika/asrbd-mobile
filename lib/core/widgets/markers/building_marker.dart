import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingMarker extends StatelessWidget {
  final Map<String, dynamic>? buildingsData;
  final int? selectedObjectId;
  final ShapeType? selectedShapeType;
  final Function onTap;
  const BuildingMarker(
      {super.key,
      this.buildingsData,
      this.selectedObjectId,
      this.selectedShapeType,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return buildingsData != null
        ? PolygonLayer(
            polygons:
                List<Map<String, dynamic>>.from(buildingsData!['features'])
                    .map((feature) {
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
          )
        : const SizedBox();
  }
}

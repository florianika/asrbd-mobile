import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingMarker extends StatefulWidget {
  final Map<String, dynamic>? buildingsData;
  final int? selectedObjectId;
  final ShapeType? selectedShapeType;
  final String attributeLegend;
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
    required this.attributeLegend,
  });

  @override
  State<BuildingMarker> createState() => _BuildingMarkerState();
}

class _BuildingMarkerState extends State<BuildingMarker> {
  final legendService = sl<LegendService>();

  @override
  Widget build(BuildContext context) {
    if (widget.buildingsData == null) return const SizedBox();

    final features =
        List<Map<String, dynamic>>.from(widget.buildingsData!['features']);

    return Stack(
      children: [
        PolygonLayer(
          polygons: features.map((feature) {
            final props = feature['properties'] as Map<String, dynamic>;
            final value = props['BldQuality'];

            Color fillColor = legendService.getColorForValue(
                    LegendType.building, widget.attributeLegend, value) ??
                Colors.black;
            if (widget.selectedShapeType == ShapeType.polygon &&
                widget.selectedObjectId == props['OBJECTID']) {
              fillColor = Colors.red;
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

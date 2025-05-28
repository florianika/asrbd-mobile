import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingMarker extends StatefulWidget {
  final Map<String, dynamic>? buildingsData;
  final String? selectedGlobalID;
  final ShapeType? selectedShapeType;
  final String attributeLegend;
  final String? highlightedBuildingIds;

  const BuildingMarker({
    super.key,
    this.buildingsData,
    this.selectedGlobalID,
    this.selectedShapeType,
    required this.attributeLegend,
    required this.highlightedBuildingIds,
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
          polygons: features.where((feature) {
            final props = feature['properties'] as Map<String, dynamic>;
            return widget.highlightedBuildingIds == props['GlobalID'];
          }).map((feature) {
            final coords = GeometryHelper.parseCoordinates(feature['geometry']);
            return Polygon(
              points: coords,
              color: const Color.fromARGB(255, 222, 31, 17).withOpacity(0.01),
              borderColor:
                  const Color.fromARGB(255, 215, 25, 11).withOpacity(0.3),
              borderStrokeWidth: 16.0,
            );
          }).toList(),
        ),
        PolygonLayer(
          polygons: features.map((feature) {
            final props = feature['properties'] as Map<String, dynamic>;
            final value = widget.attributeLegend == 'quality'
                ? props['BldQuality']
                : props['BldReview'];

            Color fillColor = legendService.getColorForValue(
                    LegendType.building, widget.attributeLegend, value) ??
                Colors.black;
            if (widget.selectedShapeType == ShapeType.polygon &&
                widget.selectedGlobalID == props['GlobalID']) {
              fillColor = Colors.red;
            }

            return Polygon(
              points: GeometryHelper.parseCoordinates(feature['geometry']),
              color: fillColor,
              borderStrokeWidth: 1.0,
            );
          }).toList(),
        ),
      ],
    );
  }
}

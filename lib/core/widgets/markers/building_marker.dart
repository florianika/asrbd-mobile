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
  final Function(String) onTap;

  const BuildingMarker({
    super.key,
    this.buildingsData,
    this.selectedGlobalID,
    this.selectedShapeType,
    required this.attributeLegend,
    required this.highlightedBuildingIds,
    required this.onTap,
  });

  @override
  State<BuildingMarker> createState() => _BuildingMarkerState();
}

class _BuildingMarkerState extends State<BuildingMarker> {
  final legendService = sl<LegendService>();
  final LayerHitNotifier<Object> _hitNotifier = LayerHitNotifier(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hitNotifier.dispose();
    super.dispose();
  }

  void _onPolygonHit() {
    final hits = _hitNotifier.value;
    if (hits != null) {
      final globalId = hits.hitValues.first;
      widget.onTap(globalId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildingsData == null) return const SizedBox();

    final features =
        List<Map<String, dynamic>>.from(widget.buildingsData!['features']);

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTapUp: (TapUpDetails details) {
            _onPolygonHit();
          },
          child: PolygonLayer(
            hitNotifier: _hitNotifier,
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
                fillColor = Colors.red.withOpacity(0.7);
              }

              return Polygon(
                hitValue: props['GlobalID'],
                points: GeometryHelper.parseCoordinates(feature['geometry']),
                color: fillColor,
                label: props['OBJECTID'].toString(),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      offset: Offset(-1.0, -1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.0, -1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(-1.0, 1.0),
                      color: Colors.black,
                    ),
                  ],
                ),
                borderStrokeWidth:
                    widget.highlightedBuildingIds != props['GlobalID']
                        ? 1.0
                        : 8.0,
                borderColor: widget.highlightedBuildingIds != props['GlobalID']
                    ? Colors.blue
                    : const Color.fromARGB(255, 215, 25, 11).withOpacity(0.3),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

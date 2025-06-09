import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class EntranceMarker extends StatefulWidget {
  final Map<String, dynamic>? entranceData;
  final String? selectedGlobalId;
  final ShapeType? selectedShapeType;
  final String attributeLegend;
  final Function onTap;
  final MapController mapController; // Add MapController to control zoom
  final List<dynamic> highilghGlobalIds;

  const EntranceMarker({
    super.key,
    this.entranceData,
    this.selectedGlobalId,
    this.selectedShapeType,
    required this.onTap,
    required this.mapController,
    required this.highilghGlobalIds, required this.attributeLegend,
  });

  @override
  State<EntranceMarker> createState() => _EntranceMarkerState();
}

class _EntranceMarkerState extends State<EntranceMarker> {
  final legendService = sl<LegendService>();
  final markerSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return widget.entranceData != null && widget.entranceData!.isNotEmpty
        ? MarkerLayer(
            markers: widget.entranceData! == {}
                ? []
                : List<Map<String, dynamic>>.from(
                        widget.entranceData!['features'])
                    .map((feature) {
                    final props = feature['properties'] as Map<String, dynamic>;
                    final value = props['EntQuality'];
                    final globalId = props[EntranceFields.globalID];

                    Color fillColor = legendService.getColorForValue(
                            LegendType.entrance, widget.attributeLegend, value) ??
                        Colors.black;

                    if (widget.selectedShapeType == ShapeType.point &&
                        widget.selectedGlobalId != null &&
                        widget.selectedGlobalId == globalId) {
                      fillColor = Colors.red;
                    }

                    return Marker(
                      width: markerSize,
                      height: markerSize,
                      point:
                          GeometryHelper.parseCoordinates(feature['geometry'])
                              .first,
                      child: GestureDetector(
                        onTap: () {
                          widget.onTap(props);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Main marker
                            Container(
                              width: markerSize,
                              height: markerSize,
                              decoration: BoxDecoration(
                                color: fillColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.highilghGlobalIds
                                          .contains(globalId)
                                      ? Colors.red
                                      : Colors.black,
                                  width: widget.highilghGlobalIds
                                          .contains(globalId)
                                      ? 3
                                      : 1,
                                ),
                                boxShadow: widget.highilghGlobalIds
                                        .contains(globalId)
                                    ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.6),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            // Label positioned above the marker
                            if (widget.highilghGlobalIds.contains(globalId))
                              Positioned(
                                bottom:
                                    markerSize + 5, // Position above the marker
                                left:
                                    -15, // Center the label (adjust based on label width)
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    props['OBJECTID']?.toString() ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
          )
        : const SizedBox();
  }
}

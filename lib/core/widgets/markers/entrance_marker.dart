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
    required this.highilghGlobalIds,
  });

  @override
  State<EntranceMarker> createState() => _EntranceMarkerState();
}

class _EntranceMarkerState extends State<EntranceMarker> {
  final legendService = sl<LegendService>();
  final markerSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return widget.entranceData != null
        ? MarkerLayer(
            markers: widget.entranceData! == {}
                ? []
                : List<Map<String, dynamic>>.from(
                        widget.entranceData!['features'])
                    .map((feature) {
                    final props = feature['properties'] as Map<String, dynamic>;
                    final value = props['EntQuality'];
                    final globalId = props[EntranceFields.globalID];

                    // Dynamically adjust marker size based on zoom level
                    // final zoomLevel = widget.mapController.camera.zoom;
                    // double markerSize =
                    //     (30 * zoomLevel / 40 > 25) ? 25 : 30 * zoomLevel / 40;

                    // // Ensure a minimum and maximum size
                    // markerSize = markerSize.clamp(20.0, 100.0);

                    Color fillColor = legendService.getColorForValue(
                            LegendType.entrance, 'quality', value) ??
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
                        child: widget.highilghGlobalIds.contains(globalId)
                            ? Container(
                                decoration: BoxDecoration(
                                    color: fillColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red
                                            .withOpacity(0.6), // glow color
                                        blurRadius: 10,
                                        spreadRadius: 3,
                                      ),
                                    ]),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: fillColor,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                              ),
                      ),
                    );
                  }).toList(),
          )
        : const SizedBox();
  }
}

import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/entrance_helper.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EntranceMarker extends StatefulWidget {
  final Map<String, dynamic>? entranceData;
  final String attributeLegend;
  final Function onTap;
  final MapController mapController;

  const EntranceMarker({
    super.key,
    this.entranceData,
    required this.onTap,
    required this.mapController,
    required this.attributeLegend,
  });

  @override
  State<EntranceMarker> createState() => _EntranceMarkerState();
}

class _EntranceMarkerState extends State<EntranceMarker> {
  final legendService = sl<LegendService>();
  final double markerSize = 20.0;

  // Keep track of dragged entrances
  final Map<String, LatLng> _draggedEntrances = {};

  @override
  void didUpdateWidget(EntranceMarker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the entrance data has changed, update our dragged entrances map
    if (widget.entranceData != oldWidget.entranceData) {
      _updateDraggedEntrancesFromData();
    }
  }

  // Update the dragged entrances map from the current entrance data
  void _updateDraggedEntrancesFromData() {
    if (widget.entranceData == null || widget.entranceData!.isEmpty) return;

    final features = widget.entranceData!['features'] as List<dynamic>?;
    if (features == null) return;

    // Clear any dragged entrances that are no longer in the data
    final currentIds = <String>{};

    for (final feature in features) {
      if (feature is Map<String, dynamic>) {
        final props = feature['properties'] as Map<String, dynamic>?;
        if (props != null) {
          final globalId = props['GlobalID']?.toString().removeCurlyBraces();
          if (globalId != null) {
            currentIds.add(globalId);
          }
        }
      }
    }

    // Remove any dragged entrances that are no longer in the data
    _draggedEntrances.removeWhere((key, value) => !currentIds.contains(key));
  }

  void _handleDragEnd(
    DraggableDetails details,
    String globalId,
    Map<String, dynamic> properties,
    MapController mapController,
    BuildContext context,
  ) {
    // Get the map's current visible bounds
    final bounds = mapController.camera.visibleBounds;

    // Calculate the relative position of the drop within the visible map area
    final screenSize = MediaQuery.of(context).size;
    final relativeX = details.offset.dx / screenSize.width;
    final relativeY = details.offset.dy / screenSize.height;

    // Convert the relative screen position to map coordinates
    final spanLat = bounds.north - bounds.south;
    final spanLng = bounds.east - bounds.west;

    // Calculate the new position using the same logic as when adding a new entrance
    final newLat = bounds.north - (spanLat * relativeY);
    final newLng = bounds.west + (spanLng * relativeX);

    final newPosition = LatLng(newLat, newLng);

    // Store the dragged position
    _draggedEntrances[globalId] = newPosition;

    // Force a rebuild to update the marker position
    setState(() {});

    // Open the entrance form with the updated position
    _openEntranceForm(globalId, properties, newPosition, context);
  }

  void _openEntranceForm(
    String globalId,
    Map<String, dynamic> properties,
    LatLng newPosition,
    BuildContext context,
  ) {
    try {
      // Create a copy of the properties to update
      final updatedProperties = Map<String, dynamic>.from(properties);

      // Update the latitude and longitude properties in the form data
      updatedProperties['EntLatitude'] = newPosition.latitude;
      updatedProperties['EntLongitude'] = newPosition.longitude;

      // Add editor information if needed
      updatedProperties['external_editor_date'] =
          DateTime.now().millisecondsSinceEpoch;

      // Get the building ID from the properties
      final buildingGlobalId =
          properties[EntranceFields.entBldGlobalID]?.toString();

      // Create a list with the single point for the new position
      final points = [newPosition];

      // Update the geometry in the NewGeometryCubit
      final geometryCubit = context.read<NewGeometryCubit>();
      geometryCubit.setPoints(points);
      geometryCubit.setType(ShapeType.point);

      // Show the entrance form by triggering the AttributesCubit
      final attributesCubit = context.read<AttributesCubit>();

      // First, make sure the attributes panel is visible
      attributesCubit.showAttributes(true);

      // Then, show the entrance attributes with the updated position
      attributesCubit.showEntranceAttributes(globalId, buildingGlobalId);

      // Update the entrance position in the database when the form is opened
      // This ensures the changes persist when the form is saved
      // IMPORTANT: Pass both the updated properties AND the points to ensure the geometry is updated
      final entranceCubit = context.read<EntranceCubit>();
      entranceCubit.updateEntranceFeature(updatedProperties, points);

      // Provide feedback that the entrance is ready to be edited
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrance moved - review and save changes'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show an error message if there's a problem opening the form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update entrance position: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entranceData = widget.entranceData;
    if (entranceData == null || entranceData.isEmpty) return const SizedBox();

    return BlocConsumer<AttributesCubit, AttributesState>(
      listener: (context, state) {
        if (state is AttributesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final attributesCubit = context.read<AttributesCubit>();
        final currentBldId =
            attributesCubit.currentBuildingGlobalId?.removeCurlyBraces();
        final currentEntId =
            attributesCubit.currentEntranceGlobalId?.removeCurlyBraces();
        final shapeType = attributesCubit.shapeType;

        final features =
            List<Map<String, dynamic>>.from(entranceData['features']);

        return MarkerLayer(
          markers: features.map((feature) {
            final props = Map<String, dynamic>.from(feature['properties']);
            final globalId = props['GlobalID']?.toString().removeCurlyBraces();
            final buildingGlobalId = props[EntranceFields.entBldGlobalID]
                ?.toString()
                .removeCurlyBraces();

            final isSelected = globalId != null && globalId == currentEntId;
            final isPolygonMatch = shapeType == ShapeType.polygon &&
                buildingGlobalId == currentBldId;

            final fillColor = isSelected
                ? Colors.red.withOpacity(0.7)
                : legendService.getColorForValue(
                      LegendType.entrance,
                      widget.attributeLegend,
                      props['EntQuality'],
                    ) ??
                    Colors.black;

            final label = EntranceHelper.entranceLabel(
              props['EntBuildingNumber'],
              props['EntEntranceNumber'],
            );

            // Use the dragged position if available, otherwise use the original position
            final entrancePoint = _draggedEntrances[globalId] ??
                GeometryHelper.parseCoordinates(feature['geometry']).first;

            return Marker(
              width: markerSize,
              height: markerSize,
              point: entrancePoint,
              child: LongPressDraggable<Map<String, dynamic>>(
                // Use LongPressDraggable instead of Draggable for more intuitive interaction
                data: {
                  'globalId': globalId,
                  'properties': props,
                  'initialPosition': entrancePoint,
                },
                // Make the drag feedback larger and more visible
                feedback: Container(
                  width: markerSize * 1.5,
                  height: markerSize * 1.5,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.drag_indicator,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                // Show a clear placeholder when dragging
                childWhenDragging: Container(
                  width: markerSize,
                  height: markerSize,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.move_down,
                      color: Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
                // Provide haptic feedback when drag starts
                onDragStarted: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Moving entrance...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                // Handle the drag end
                onDragEnd: (details) => _handleDragEnd(
                  details,
                  globalId!,
                  props,
                  widget.mapController,
                  context,
                ),
                // The actual marker that responds to taps
                child: GestureDetector(
                  onTap: () => widget.onTap(props),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: markerSize,
                        height: markerSize,
                        decoration: BoxDecoration(
                          color: fillColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isPolygonMatch ? Colors.red : Colors.black,
                            width: isPolygonMatch ? 3 : 1,
                          ),
                          boxShadow: isPolygonMatch
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
                      if (isPolygonMatch && label != null)
                        Positioned(
                          bottom: markerSize + 5,
                          left: -15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              label,
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
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

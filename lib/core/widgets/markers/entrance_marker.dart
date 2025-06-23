import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/entrance_helper.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class EntranceMarker extends StatefulWidget {
  final Map<String, dynamic>? entranceData;
  // final String? selectedGlobalId;
  // final ShapeType? selectedShapeType;
  final String attributeLegend;
  final Function onTap;
  final MapController mapController;
  // final List<dynamic> highilghGlobalIds;

  const EntranceMarker({
    super.key,
    this.entranceData,
    // this.selectedGlobalId,
    // this.selectedShapeType,
    required this.onTap,
    required this.mapController,
    // required this.highilghGlobalIds,
    required this.attributeLegend,
  });

  @override
  State<EntranceMarker> createState() => _EntranceMarkerState();
}

class _EntranceMarkerState extends State<EntranceMarker> {
  final legendService = sl<LegendService>();
  final double markerSize = 20.0;

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

            return Marker(
              width: markerSize,
              height: markerSize,
              point: GeometryHelper.parseCoordinates(feature['geometry']).first,
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
            );
          }).toList(),
        );
      },
    );
  }
}

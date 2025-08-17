import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/entrance_helper.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class EntranceMarker extends StatefulWidget {
  final List<EntranceEntity> entranceData;
  final String attributeLegend;
  final Function onTap;
  final Function onLongPress;
  final MapController mapController;

  const EntranceMarker({
    super.key,
    required this.entranceData,
    required this.onTap,
    required this.onLongPress,
    required this.mapController,
    required this.attributeLegend,
  });

  @override
  State<EntranceMarker> createState() => _EntranceMarkerState();
}

class _EntranceMarkerState extends State<EntranceMarker> {
  final legendService = sl<LegendService>();
  final double markerSize = 25.0;

  @override
  Widget build(BuildContext context) {
    final entranceData = widget.entranceData;
    if (entranceData.isEmpty) return const SizedBox();

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
        final currentBldId = attributesCubit.currentBuildingGlobalId;
        final currentEntId = attributesCubit.currentEntranceGlobalId;
        final shapeType = attributesCubit.shapeType;

        return MarkerLayer(
          markers: entranceData.map((entrance) {
            final isSelected = entrance.globalId == currentEntId;
            final isPolygonMatch = shapeType == ShapeType.polygon &&
                entrance.entBldGlobalID == currentBldId;

            final fillColor = isSelected
                ? Colors.red.withOpacity(0.7)
                : legendService.getColorForValue(
                      LegendType.entrance,
                      widget.attributeLegend,
                      entrance.entQuality ?? 9,
                    ) ??
                    Colors.black;

            final label = EntranceHelper.entranceLabel(
              entrance.entBuildingNumber,
              entrance.entEntranceNumber,
            );

            return Marker(
              width: markerSize,
              height: markerSize,
              point: entrance.coordinates!,
              child: GestureDetector(
                onTap: () => widget.onTap(entrance),
                onLongPress: () =>
                    widget.onLongPress(entrance),
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

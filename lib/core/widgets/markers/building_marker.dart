import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingMarker extends StatefulWidget {
  final List<BuildingEntity>? buildingsData;
  final String attributeLegend;

  const BuildingMarker({
    super.key,
    this.buildingsData,
    required this.attributeLegend,
  });

  @override
  State<BuildingMarker> createState() => _BuildingMarkerState();
}

class _BuildingMarkerState extends State<BuildingMarker> {
  final legendService = sl<LegendService>();
  String globalId = '';

  @override
  Widget build(BuildContext context) {
    final buildingsData = widget.buildingsData;
    if (buildingsData == null || buildingsData.isEmpty) return const SizedBox();

    return Stack(
      children: [
        BlocConsumer<AttributesCubit, AttributesState>(
          listener: (context, state) {
            if (state is AttributesError) {
              NotifierService.showMessage(
                context,
                message: state.message,
                type: MessageType.error,
              );
            }
          },
          builder: (context, state) {
            final attributesCubit = context.read<AttributesCubit>();
            final currentBldId = attributesCubit.currentBuildingGlobalId;
            final shapeType = attributesCubit.shapeType;

            return PolygonLayer(
              polygons: buildingsData.map((building) {
                try {
                  final globalId = building.globalId;
                  final value = widget.attributeLegend == 'quality'
                      ? building.bldQuality
                      : building.bldReview;

                  final isSelected = currentBldId == globalId;
                  final isPointType = shapeType == ShapeType.point;

                  final fillColor = isSelected
                      ? Colors.red.withOpacity(0.7)
                      : legendService.getColorForValue(LegendType.building,
                              widget.attributeLegend, value!) ??
                          Colors.black;

                  final borderColor = isSelected && isPointType
                      ? const Color.fromARGB(255, 215, 25, 11).withOpacity(0.3)
                      : Colors.blue;

                  final borderStrokeWidth =
                      isSelected && isPointType ? 8.0 : 1.0;

                  return Polygon(
                    hitValue: building.globalId,
                    points: building.coordinates.first,
                    color: fillColor,
                    borderStrokeWidth: borderStrokeWidth,
                    borderColor: borderColor,
                  );
                } catch (e) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    NotifierService.showMessage(
                      context,
                      message: e.toString(),
                      type: MessageType.error,
                    );
                  });

                  // Return an empty polygon or skip rendering this one
                  return Polygon(points: []);
                }
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

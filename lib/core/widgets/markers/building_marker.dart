import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingMarker extends StatefulWidget {
  final Map<String, dynamic>? buildingsData;
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

    final features = List<Map<String, dynamic>>.from(buildingsData['features']);

    return Stack(
      children: [
        BlocConsumer<AttributesCubit, AttributesState>(
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
            final shapeType = attributesCubit.shapeType;

            return PolygonLayer(                      
              polygons: features.map((feature) {
                final props = Map<String, dynamic>.from(feature['properties']);
                final globalId =
                    props['GlobalID']?.toString().removeCurlyBraces() ?? '';
                final value = widget.attributeLegend == 'quality'
                    ? props['BldQuality']
                    : props['BldReview'];

                final isSelected = currentBldId == globalId;
                final isPointType = shapeType == ShapeType.point;

                final fillColor =
                    isSelected // && shapeType == ShapeType.polygon
                        ? Colors.red.withOpacity(0.7)
                        : legendService.getColorForValue(LegendType.building,
                                widget.attributeLegend, value) ??
                            Colors.black;

                final borderColor = isSelected && isPointType
                    ? const Color.fromARGB(255, 215, 25, 11).withOpacity(0.3)
                    : Colors.blue;

                final borderStrokeWidth = isSelected && isPointType ? 8.0 : 1.0;

                return Polygon(
                  hitValue: props['GlobalID'],
                  points: GeometryHelper.parseCoordinates(feature['geometry']),
                  color: fillColor,
                  borderStrokeWidth: borderStrokeWidth,
                  borderColor: borderColor,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

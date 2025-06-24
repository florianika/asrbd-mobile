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
  final Function(String) onTap;

  const BuildingMarker({
    super.key,
    this.buildingsData,
    required this.attributeLegend,
    required this.onTap,
  });

  @override
  State<BuildingMarker> createState() => _BuildingMarkerState();
}

class _BuildingMarkerState extends State<BuildingMarker> {
  final legendService = sl<LegendService>();
  final LayerHitNotifier<Object> _hitNotifier = LayerHitNotifier(null);
  String globalId = '';

  @override
  void dispose() {
    _hitNotifier.dispose();
    super.dispose();
  }

  void _onPolygonHit() {
    final hits = _hitNotifier.value;
    if (hits != null && hits.hitValues.isNotEmpty) {
      final id = hits.hitValues.first.toString();
      widget.onTap(id);
      setState(() => globalId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buildingsData = widget.buildingsData;
    if (buildingsData == null || buildingsData.isEmpty) return const SizedBox();

    final features = List<Map<String, dynamic>>.from(buildingsData['features']);

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTapUp: (_) => _onPolygonHit(),
          child: BlocConsumer<AttributesCubit, AttributesState>(
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
                hitNotifier: _hitNotifier,
                polygons: features.map((feature) {
                  final props =
                      Map<String, dynamic>.from(feature['properties']);
                  final globalId =
                      props['GlobalID']?.toString().removeCurlyBraces() ?? '';
                  final value = widget.attributeLegend == 'quality'
                      ? props['BldQuality']
                      : props['BldReview'];

                  final isSelected = currentBldId == globalId;
                  final isPointType = shapeType == ShapeType.point;

                  final fillColor = isSelected && shapeType == ShapeType.polygon
                      ? Colors.red.withOpacity(0.7)
                      : legendService.getColorForValue(LegendType.building,
                              widget.attributeLegend, value) ??
                          Colors.black;

                  final borderColor = isSelected && isPointType
                      ? const Color.fromARGB(255, 215, 25, 11).withOpacity(0.3)
                      : Colors.blue;

                  final borderStrokeWidth =
                      isSelected && isPointType ? 8.0 : 1.0;

                  return Polygon(
                    hitValue: props['GlobalID'],
                    points:
                        GeometryHelper.parseCoordinates(feature['geometry']),
                    color: fillColor,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(offset: Offset(-1.0, -1.0), color: Colors.black),
                        Shadow(offset: Offset(1.0, -1.0), color: Colors.black),
                        Shadow(offset: Offset(1.0, 1.0), color: Colors.black),
                        Shadow(offset: Offset(-1.0, 1.0), color: Colors.black),
                      ],
                    ),
                    borderStrokeWidth: borderStrokeWidth,
                    borderColor: borderColor,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

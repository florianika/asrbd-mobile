import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class EntrancesMarker extends StatefulWidget {
  final String attributeLegend;
  final Function onTap;
  final Function onLongPress;
  final MapController mapController;

  const EntrancesMarker({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.mapController,
    required this.attributeLegend,
  });

  @override
  State<EntrancesMarker> createState() => _EntrancesMarkerState();
}

class _EntrancesMarkerState extends State<EntrancesMarker> {
  final legendService = sl<LegendService>();
  final double markerSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttributesCubit, AttributesState>(
      builder: (context, attributesState) {
        return BlocConsumer<EntranceCubit, EntranceState>(
          listener: (context, state) {},
          builder: (context, state) {
            final attributesCubit = context.read<AttributesCubit>();
            // final currentBldId = attributesCubit.currentBuildingGlobalId;
            final currentEntId = attributesCubit.currentEntranceGlobalId;
            // final shapeType = attributesCubit.shapeType;

            if (state is! Entrances) {
              return SizedBox.shrink();
            }

            if (state.entrances.isEmpty) {
              return SizedBox.shrink();
            }

            return MarkerLayer(
              markers: state.entrances.map((entrance) {
                final isSelected = entrance.globalId == currentEntId;

                return Marker(
                  width: markerSize,
                  height: markerSize,
                  point: entrance.coordinates!,
                  child: GestureDetector(
                    onTap: () => widget.onTap(entrance),
                    onLongPress: () => widget.onLongPress(entrance),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: markerSize,
                          height: markerSize,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 0, 1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromRGBO(130, 127, 0, 1),
                              width: isSelected ? 4 : 1,
                            ),
                          ),
                        ),
                        if (entrance.entEntranceNumber != null)
                          Positioned(
                            bottom: markerSize + 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4A90E2),
                                        Color(0xFF357ABD),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    entrance.entEntranceNumber!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                CustomPaint(
                                  size: Size(12, 8),
                                  painter: BalloonTailPainter(),
                                ),
                              ],
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
      },
    );
  }
}

class BalloonTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF357ABD)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2 - 6, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 + 6, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

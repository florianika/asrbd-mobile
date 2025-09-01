import 'package:asrdb/core/enums/service_mode.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/presentation/municipality_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MunicipalityMarker extends StatefulWidget {
  final bool isOffline;
  final int? municipalityId;
  const MunicipalityMarker({
    super.key,
    required this.isOffline,
    this.municipalityId,
  });

  @override
  State<MunicipalityMarker> createState() => _MunicipalityMarkerState();
}

class _MunicipalityMarkerState extends State<MunicipalityMarker> {
  final userService = sl<UserService>();
  @override
  void initState() {
    super.initState();
    context.read<MunicipalityCubit>().getMunicipality(
          widget.isOffline
              ? widget.municipalityId!
              : userService.userInfo!.municipality,
          widget.isOffline ? ServiceMode.offline : ServiceMode.online,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final features = List<Map<String, dynamic>>.from(buildingsData['features']);

    return BlocConsumer<MunicipalityCubit, MunicipalityState>(
      listener: (context, state) {
        if (state is MunicipalityError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is! Municipality) return const SizedBox();
        final polygons = <Polygon>[];

        if (state.municipality == null) {
          return SizedBox.shrink();
        }

        if (state.municipality!.geometryType == 'Polygon') {
          polygons.add(
            Polygon(
              points: state.municipality!.coordinates.first.first,
              color: Colors.transparent,
              borderColor: Colors.red,
              borderStrokeWidth: 2.0,
            ),
          );
        } else if (state.municipality!.geometryType == 'MultiPolygon') {
          for (final polygon in state.municipality!.coordinates) {
            final outerRing = polygon.first;

            polygons.add(
              Polygon(
                points: outerRing,
                color: Colors.transparent,
                borderColor: Colors.red,
                borderStrokeWidth: 2.0,
              ),
            );
          }
        }

        return PolygonLayer(polygons: polygons);
      },
    );
  }
}

import 'package:asrdb/core/enums/service_mode.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/presentation/municipality_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MunicipalityMarker extends StatefulWidget {
  const MunicipalityMarker({
    super.key,
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
        userService.userInfo!.municipality, ServiceMode.online);
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

        final features =
            List<Map<String, dynamic>>.from(state.municipality!['features']);

        return PolygonLayer(
          polygons: features.expand((feature) {
            final geometry = feature['geometry'];
            final type = geometry['type'];
            final polygons = <Polygon>[];

            if (type == 'Polygon') {
              final points = GeometryHelper.parseCoordinates(geometry);
              polygons.add(
                Polygon(
                  points: points,
                  color: Colors.transparent,
                  borderColor: Colors.red,
                  borderStrokeWidth: 2.0,
                ),
              );
            } else if (type == 'MultiPolygon') {
              final multiCoords = geometry['coordinates'] as List;
              for (final polygon in multiCoords) {
                final outerRing = polygon.first;
                final points = outerRing
                    .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                    .toList();
                polygons.add(
                  Polygon(
                    points: points,
                    color: Colors.transparent,
                    borderColor: Colors.red,
                    borderStrokeWidth: 2.0,
                  ),
                );
              }
            }

            return polygons;
          }).toList(),
        );
      },
    );
  }
}

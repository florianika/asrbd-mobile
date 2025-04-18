import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:asrdb/core/widgets/file_tile_provider.dart' as _ft;

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  bool _isInitialized = true;
  late String tileDirPath = '';

  MapController mapController = MapController();
  GeoJsonParser entranceGeoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  GeoJsonParser buildinGeoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  Future<void> _initialize() async {
    context.read<BuildingCubit>().getBuildings();
    context.read<EntranceCubit>().getEntrances();
  }

  void handleMarkerTap(Map<String, dynamic> data) {
    // _showPopup(context, data[EntranceFields.objectID].toString());
    //TODO: show  popup
  }

  @override
  void initState() {
    super.initState();
    _initialize();

    entranceGeoJsonParser.onMarkerTapCallback = handleMarkerTap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map")),
      drawer: const SideMenu(),
      body: BlocConsumer<BuildingCubit, BuildingState>(
        listener: (context, state) {
          if (state is Buildings) {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.buildings.length.toString())),
              );

              buildinGeoJsonParser.parseGeoJson(state.buildings);
            });
          } else if (state is BuildingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return BlocConsumer<EntranceCubit, EntranceState>(
            listener: (context, state) {
              if (state is Entrances) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.entrances.length.toString())),
                  );

                  entranceGeoJsonParser.parseGeoJson(state.entrances);
                });
              } else if (state is EntranceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: const MapOptions(
                      initialCenter: LatLng(40.534406, 19.6338131),
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        tileProvider: _ft.FileTileProvider(tileDirPath, false),
                      ),
                      MarkerLayer(markers: entranceGeoJsonParser.markers),
                      PolygonLayer(
                        polygons: buildinGeoJsonParser.polygons,
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

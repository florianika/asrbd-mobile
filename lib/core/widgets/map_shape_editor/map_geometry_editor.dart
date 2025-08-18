import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapGeometryEditor extends StatelessWidget {
  final MapController mapController;
  const MapGeometryEditor({
    super.key,
    required this.mapController,
  });

  void _goToCurrentLocation() async {
    final location = await LocationService.getCurrentLocation();
    mapController.move(location, AppConfig.initZoom);
  }

  @override
  Widget build(BuildContext context) {
    final attributeContext = context.watch<AttributesCubit>();
    return Stack(
      children: [
        Positioned(
          bottom: 270,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_in',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom + 1);
            },
            icon: Icons.zoom_in,
          ),
        ),
        Positioned(
          bottom: 210,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_out',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 1);
            },
            icon: Icons.zoom_out,
          ),
        ),
        Positioned(
            bottom: 150,
            left: 20,
            child: FloatingButton(
              heroTag: 'locate_me',
              isEnabled: true,
              onPressed: _goToCurrentLocation,
              icon: Icons.my_location,
            )),
        Positioned(
          bottom: 90,
          left: 20,
          child: FloatingButton(
            heroTag: 'rectangle',
            isEnabled: true,
            onPressed: () => {
              context.read<GeometryEditorCubit>().startCreatingBuilding(),
            },
            icon: Icons.hexagon_outlined,
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          child: FloatingButton(
            heroTag: 'entrance',
            onPressed: () => {
              context.read<GeometryEditorCubit>().startCreatingEntrance(),
              context.read<AttributesCubit>().toggleAttributesVisibility(false)
            },
            isEnabled: attributeContext.currentBuildingGlobalId != null &&
                attributeContext.shapeType == ShapeType.polygon,
            icon: Icons.adjust,
          ),
        ),
      ],
    );
  }
}

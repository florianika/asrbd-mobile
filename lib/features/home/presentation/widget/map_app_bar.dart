import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<AttributesCubit, AttributesState>(
        builder: (context, state) {
          if (state is Attributes) {
            return Text('My App - ${state.buildingGlobalId ?? "None"}');
          }
          return const Text('My App');
        },
      ),
      backgroundColor: Colors.white,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.layers,
            size: 25,
          ),
          onSelected: (String result) {
            // Handle menu item selection
            switch (result) {
              case 'settings':
                break;
              case 'profile':
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'terrain',
              child: Row(
                children: [
                  Icon(Icons.terrain, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Terrain'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'satellite',
              child: Row(
                children: [
                  Icon(Icons.satellite, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Satellite'),
                ],
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.download,
            size: 25,
          ),
          onSelected: (String result) =>
              Navigator.pushNamed(context, RouteManager.downloadMapRoute),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Download'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

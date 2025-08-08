import 'package:asrdb/core/services/tile_index_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class IndexedFileTileProvider extends TileProvider {
  final TileIndexService? tileIndex;
  final bool isOffline;

  IndexedFileTileProvider({
    required this.tileIndex,
    required this.isOffline,
  });

  String _osmUrl(TileCoordinates coords) =>
      "https://tile.openstreetmap.org/${coords.z}/${coords.x}/${coords.y}.png";

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coordinates, TileLayer options) {
    final z = coordinates.z.toInt();
    final x = coordinates.x.toInt();
    final y = coordinates.y.toInt();

    if (!isOffline) return NetworkImage(_osmUrl(coordinates));

    if (tileIndex != null && tileIndex!.hasTile(z, x, y)) {
      return FileImage(tileIndex!.getFile(z, x, y));
    } else {
      return const AssetImage('assets/img/empty_tile.png');
    }
  }
}

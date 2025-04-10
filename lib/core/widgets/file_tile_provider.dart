import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class FileTileProvider extends TileProvider {
  final String tileDirPath;
  final bool isOffline;

  FileTileProvider(this.tileDirPath, this.isOffline);

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coordinates, TileLayer options) {
    if (!isOffline) {
      String url =
          "https://tile.openstreetmap.org/${coordinates.z}/${coordinates.x}/${coordinates.y}.png";
      return NetworkImage(url);
    }
    
    String filePath =
        "$tileDirPath/${coordinates.z}/${coordinates.x}/${coordinates.y}.png";
    File file = File(filePath);

    if (file.existsSync()) {
      return FileImage(file);
    } else {
      String url =
          "https://tile.openstreetmap.org/${coordinates.z}/${coordinates.x}/${coordinates.y}.png";
      return NetworkImage(url);
    }
  }
}

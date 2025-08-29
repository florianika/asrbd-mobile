import 'dart:io';

import 'package:asrdb/core/services/tile_index_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:ui' as ui;

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
      return DelayedFileImage(tileIndex!.getFile(z, x, y),
          delay: const Duration(milliseconds: 30));
    } else {
      return const AssetImage('assets/img/empty_tile.png');
    }
  }
}

/// An ImageProvider that adds an artificial delay before loading a FileImage.
class DelayedFileImage extends ImageProvider<DelayedFileImage> {
  final File file;
  final Duration delay;

  const DelayedFileImage(this.file,
      {this.delay = const Duration(milliseconds: 30)});

  @override
  Future<DelayedFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DelayedFileImage>(this);
  }

  /// New method in recent Flutter versions
  @override
  ImageStreamCompleter loadImage(
      DelayedFileImage key, ImageDecoderCallback decode) {
    assert(key == this);

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(ImageDecoderCallback decode) async {
    // Artificial delay
    await Future.delayed(delay);

    // Read bytes from file
    final bytes = await file.readAsBytes();

    // Convert bytes to ImmutableBuffer
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);

    // Decode using the proper callback signature
    return await decode(buffer, getTargetSize: null);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DelayedFileImage &&
          runtimeType == other.runtimeType &&
          file.path == other.file.path;

  @override
  int get hashCode => file.path.hashCode;
}

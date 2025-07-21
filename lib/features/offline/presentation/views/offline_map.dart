import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';

class OfflineMap extends StatefulWidget {
  const OfflineMap({super.key});

  @override
  State<OfflineMap> createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  final MapController _mapController = MapController();

  final double squareSize = 200;
  final int _minZoom = 10;
  final int _maxZoom = 16;

  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  LatLngBounds? _downloadBounds;

  void _calculateDownloadBounds() {
    // Get the camera from the map controller
    final camera = _mapController.camera;

    // Get the size of the map widget
    final mapSize = MediaQuery.of(context).size;
    final center = Offset(mapSize.width / 2, mapSize.height / 2);

    final topLeft =
        Offset(center.dx - squareSize / 2, center.dy - squareSize / 2);
    final bottomRight =
        Offset(center.dx + squareSize / 2, center.dy + squareSize / 2);

    // Convert pixel coordinates to LatLng using the camera
    final nw = camera.pointToLatLng(Point(topLeft.dx, topLeft.dy));
    final se = camera.pointToLatLng(Point(bottomRight.dx, bottomRight.dy));

    setState(() {
      _downloadBounds = LatLngBounds.fromPoints([nw, se]);
    });
  }

  void _downloadArea() async {
    _calculateDownloadBounds();

    if (_downloadBounds != null) {
      print(
          'Downloading area bounds: ${_downloadBounds!.northWest} - ${_downloadBounds!.southEast}');
      await _downloadOfflineTiles();
    }
  }

  String _getRelativePreviewPath(String fullPath, String basePath) {
    // Extract the relative path from the full path
    // Example: if fullPath is "/path/to/offline_maps/session/tiles/13/4185/2862.png"
    // and basePath is "/path/to/offline_maps/session"
    // return "13/4185/2862.png" (relative to tiles folder)

    if (fullPath.contains('/tiles/')) {
      final parts = fullPath.split('/tiles/');
      if (parts.length > 1) {
        return parts[1]; // Return everything after "/tiles/"
      }
    }

    // Fallback: try to extract zoom/x/y.png pattern
    final pathParts = fullPath.split('/');
    if (pathParts.length >= 3) {
      final fileName = pathParts.last;
      final xFolder = pathParts[pathParts.length - 2];
      final zoomFolder = pathParts[pathParts.length - 3];

      // Check if this looks like a tile path (zoom/x/file.png)
      if (int.tryParse(zoomFolder) != null &&
          int.tryParse(xFolder) != null &&
          fileName.endsWith('.png')) {
        return '$zoomFolder/$xFolder/$fileName';
      }
    }

    return ''; // Return null if we can't determine the relative path
  }

  Future<void> _downloadOfflineTiles() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      if (_downloadBounds == null) {
        throw Exception('Download bounds not calculated');
      }

      // Get the application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      // Create unique folder for this download session
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String sessionId = 'map_$timestamp';
      final String offlineMapPath = '${appDocDir.path}/offline_maps/$sessionId';

      // Create directory if it doesn't exist
      await Directory(offlineMapPath).create(recursive: true);

      // Calculate total tiles for progress tracking
      int totalTiles = 0;
      int downloadedTiles = 0;

      for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
        final bounds = _calculateTileBounds(_downloadBounds!, zoom);
        totalTiles += (bounds['maxX']! - bounds['minX']! + 1) *
            (bounds['maxY']! - bounds['minY']! + 1);
      }

      String? previewTilePath;

      // Download tiles for each zoom level
      for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
        final bounds = _calculateTileBounds(_downloadBounds!, zoom);

        for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
          for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
            // Construct tile URL (using OpenStreetMap)
            final tileUrl = 'https://a.tile.openstreetmap.org/$zoom/$x/$y.png';

            // Create tile file path
            final tilePath = '$offlineMapPath/tiles/$zoom/$x/$y.png';

            // Create nested directories
            await Directory('$offlineMapPath/tiles/$zoom/$x')
                .create(recursive: true);

            try {
              // Download tile
              await Dio().download(tileUrl, tilePath);

              // Save first tile from zoom 13 as preview (or any if 13 not available)
              if (previewTilePath == null || zoom == 13) {
                previewTilePath = tilePath;
              }

              // Update progress
              downloadedTiles++;
              setState(() {
                _downloadProgress = downloadedTiles / totalTiles;
              });
            } catch (e) {
              print('Failed to download tile $zoom/$x/$y: $e');
              // Continue with other tiles even if one fails
            }
          }
        }
      }

      // Save metadata for this download session
      final metadata = {
        'sessionId': sessionId,
        'name':
            'Map ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        'location':
            'Tirana, Albania', // You can make this dynamic based on center coordinates
        'downloadDate': DateTime.now().toIso8601String(),
        'bounds': {
          'northWest': {
            'lat': _downloadBounds!.northWest.latitude,
            'lng': _downloadBounds!.northWest.longitude,
          },
          'southEast': {
            'lat': _downloadBounds!.southEast.latitude,
            'lng': _downloadBounds!.southEast.longitude,
          },
        },
        'zoomLevels': {
          'min': _minZoom,
          'max': _maxZoom,
        },
        'totalTiles': downloadedTiles,
        'previewTile': previewTilePath != null
            ? _getRelativePreviewPath(previewTilePath, offlineMapPath)
            : null,
      };

      // Save metadata as JSON file
      final metadataFile = File('$offlineMapPath/metadata.json');
      await metadataFile.writeAsString(jsonEncode(metadata));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Offline map downloaded successfully! ($downloadedTiles tiles)'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading offline map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    }
  }

  Map<String, int> _calculateTileBounds(LatLngBounds bounds, int zoom) {
    // Calculate tile coordinates for the bounding box at given zoom level
    final double tileSize = 256.0;
    final double worldSize = tileSize * math.pow(2, zoom);

    // Convert lat/lng bounds to tile coordinates
    final double northWestTileX =
        (bounds.northWest.longitude + 180.0) / 360.0 * math.pow(2, zoom);
    final double northWestTileY = (1.0 -
            math.log(math.tan(bounds.northWest.latitude * math.pi / 180.0) +
                    1.0 /
                        math.cos(bounds.northWest.latitude * math.pi / 180.0)) /
                math.pi) /
        2.0 *
        math.pow(2, zoom);

    final double southEastTileX =
        (bounds.southEast.longitude + 180.0) / 360.0 * math.pow(2, zoom);
    final double southEastTileY = (1.0 -
            math.log(math.tan(bounds.southEast.latitude * math.pi / 180.0) +
                    1.0 /
                        math.cos(bounds.southEast.latitude * math.pi / 180.0)) /
                math.pi) /
        2.0 *
        math.pow(2, zoom);

    return {
      'minX': math.min(northWestTileX, southEastTileX).floor(),
      'maxX': math.max(northWestTileX, southEastTileX).floor(),
      'minY': math.min(northWestTileY, southEastTileY).floor(),
      'maxY': math.max(northWestTileY, southEastTileY).floor(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Map Downloader'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(41.3275, 19.8189), // Tirana
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
            ],
          ),

          // Fixed download square in center
          Center(
            child: IgnorePointer(
              child: Container(
                width: squareSize,
                height: squareSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.cyan,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.cyan.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Corner decorations
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.cyan, width: 3),
                            left: BorderSide(color: Colors.cyan, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.cyan, width: 3),
                            right: BorderSide(color: Colors.cyan, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.cyan, width: 3),
                            left: BorderSide(color: Colors.cyan, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.cyan, width: 3),
                            right: BorderSide(color: Colors.cyan, width: 3),
                          ),
                        ),
                      ),
                    ),
                    // Center crosshair
                    Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.cyan,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Download button with progress indicator
          Positioned(
            bottom: 30,
            right: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isDownloading) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          value: _downloadProgress,
                          color: Colors.cyan,
                          backgroundColor: Colors.grey[600],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(_downloadProgress * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                FloatingActionButton.extended(
                  onPressed: _isDownloading ? null : _downloadArea,
                  backgroundColor: _isDownloading ? Colors.grey : Colors.cyan,
                  foregroundColor: Colors.white,
                  icon: Icon(
                      _isDownloading ? Icons.hourglass_empty : Icons.download),
                  label: Text(_isDownloading ? 'Downloading...' : 'Download'),
                  elevation: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

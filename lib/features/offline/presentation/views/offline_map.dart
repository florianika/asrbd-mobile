import 'dart:math';

import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/mapper/dwelling_mapper.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/offline/domain/download_usecases.dart';
import 'package:asrdb/main.dart';
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
  final int _minZoom = 19;
  final int _maxZoom = 22;
  double _currentZoom = 19;

  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  LatLngBounds? _downloadBounds;
  LatLngBounds? _actualTileAlignedBounds;

// ADDITIONAL FIX: Ensure consistent bounds ordering
  void _calculateInitialDownloadBounds() {
    final camera = _mapController.camera;
    final mapSize = MediaQuery.of(context).size;
    final center = Offset(mapSize.width / 2, mapSize.height / 2);

    final topLeft =
        Offset(center.dx - squareSize / 2, center.dy - squareSize / 2);
    final bottomRight =
        Offset(center.dx + squareSize / 2, center.dy + squareSize / 2);

    // Convert pixel coordinates to LatLng using the camera
    final nw = camera.pointToLatLng(Point(topLeft.dx, topLeft.dy));
    final se = camera.pointToLatLng(Point(bottomRight.dx, bottomRight.dy));

    // ENSURE PROPER BOUNDS ORDERING - this is critical!
    final north = math.max(nw.latitude, se.latitude);
    final south = math.min(nw.latitude, se.latitude);
    final east = math.max(nw.longitude, se.longitude);
    final west = math.min(nw.longitude, se.longitude);

    _downloadBounds = LatLngBounds.fromPoints([
      LatLng(north, west), // Northwest
      LatLng(south, east), // Southeast
    ]);

    print('=== INITIAL BOUNDS DEBUG ===');
    print('NW point: ${nw.latitude}, ${nw.longitude}');
    print('SE point: ${se.latitude}, ${se.longitude}');
    print('Ordered bounds: N=$north, S=$south, E=$east, W=$west');
  }

  /// Calculate tile-aligned bounds that represent what will actually be downloaded
  void _calculateTileAlignedBounds() {
    if (_downloadBounds == null) return;

    // Use a middle zoom level for alignment reference
    final referenceZoom = (_minZoom + _maxZoom) ~/ 2;

    // Get tile bounds for the reference zoom
    final tileBounds = _calculateTileBounds(_downloadBounds!, referenceZoom);

    // Convert tile bounds back to geographic bounds
    _actualTileAlignedBounds = _tileIndexToBounds(tileBounds, referenceZoom);

    // Debug output
    _debugPrintBounds();
  }

  /// Hyperbolic sine function (not available in dart:math)
  double _sinh(double x) {
    return (math.exp(x) - math.exp(-x)) / 2.0;
  }

  // FIXED: More precise conversion from tile coordinates back to geographic bounds
  LatLngBounds _tileIndexToBounds(Map<String, int> tileBounds, int zoom) {
    final double zoomFactor = math.pow(2.0, zoom).toDouble();

    // Convert tile indices to precise geographic coordinates
    final double west = (tileBounds['minX']! / zoomFactor) * 360.0 - 180.0;
    final double east =
        ((tileBounds['maxX']! + 1) / zoomFactor) * 360.0 - 180.0;

    // More precise latitude calculation
    final double northY = tileBounds['minY']! / zoomFactor;
    final double southY = (tileBounds['maxY']! + 1) / zoomFactor;

    final double northRad = math.atan(_sinh(math.pi * (1 - 2 * northY)));
    final double southRad = math.atan(_sinh(math.pi * (1 - 2 * southY)));

    final double north = northRad * 180.0 / math.pi;
    final double south = southRad * 180.0 / math.pi;

    return LatLngBounds.fromPoints([
      LatLng(north, west),
      LatLng(south, east),
    ]);
  }

  /// Calculate and display the actual download bounds
  void _calculateActualDownloadBounds() {
    _calculateInitialDownloadBounds();
    _calculateTileAlignedBounds();

    // Use the tile-aligned bounds as the actual download bounds
    if (_actualTileAlignedBounds != null) {
      setState(() {
        _downloadBounds = _actualTileAlignedBounds;
      });
    }
  }

  /// Debug function to print bounds information
  void _debugPrintBounds() {
    if (_downloadBounds != null && _actualTileAlignedBounds != null) {
      print('=== BOUNDS DEBUG INFO ===');
      print('Original visual bounds:');
      print('  North: ${_downloadBounds!.north}');
      print('  South: ${_downloadBounds!.south}');
      print('  West: ${_downloadBounds!.west}');
      print('  East: ${_downloadBounds!.east}');

      print('Tile-aligned bounds:');
      print('  North: ${_actualTileAlignedBounds!.north}');
      print('  South: ${_actualTileAlignedBounds!.south}');
      print('  West: ${_actualTileAlignedBounds!.west}');
      print('  East: ${_actualTileAlignedBounds!.east}');

      // Calculate the difference
      final latDiff =
          (_actualTileAlignedBounds!.north - _actualTileAlignedBounds!.south) -
              (_downloadBounds!.north - _downloadBounds!.south);
      final lngDiff =
          (_actualTileAlignedBounds!.east - _actualTileAlignedBounds!.west) -
              (_downloadBounds!.east - _downloadBounds!.west);

      print('Area difference:');
      print('  Lat expansion: ${latDiff.toStringAsFixed(6)}°');
      print('  Lng expansion: ${lngDiff.toStringAsFixed(6)}°');

      // Show tile counts for each zoom level
      print('Tile counts by zoom level:');
      for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
        final tileBounds = _calculateTileBounds(_downloadBounds!, zoom);
        final tileCount = (tileBounds['maxX']! - tileBounds['minX']! + 1) *
            (tileBounds['maxY']! - tileBounds['minY']! + 1);
        print(
            '  Zoom $zoom: X(${tileBounds['minX']}-${tileBounds['maxX']}) Y(${tileBounds['minY']}-${tileBounds['maxY']}) = $tileCount tiles');
      }
      print('========================');
    }
  }

  void _downloadArea() async {
    // Calculate the actual tile-aligned bounds
    _calculateActualDownloadBounds();

    if (_downloadBounds != null) {
      // IMPORTANT: Ensure we're using tile-aligned bounds for building count check
      // This must be the SAME bounds used for tile download and building download
      final finalBounds = _downloadBounds!; // This is now tile-aligned

      final buildingRepository = sl<BuildingRepository>();
      final userService = sl<UserService>();

      try {
        print('=== DOWNLOAD AREA DEBUG ===');
        print('Final bounds for all operations: $finalBounds');
        print('Bounds coordinates:');
        print('  North: ${finalBounds.north}');
        print('  South: ${finalBounds.south}');
        print('  West: ${finalBounds.west}');
        print('  East: ${finalBounds.east}');

        // Check building count using the exact same bounds that will be used for download
        final noBuildings = await buildingRepository.buildingService
            .getBuildingsCount(finalBounds, userService.userInfo!.municipality);

        print('Building count in final bounds: $noBuildings');

        if (noBuildings > AppConfig.maxNoBuildings) {
          if (!mounted) return;
          NotifierService.showMessage(
            context,
            message:
                'You cannot download an area with more than ${AppConfig.maxNoBuildings} buildings. Actual number is $noBuildings',
            type: MessageType.warning,
          );
          return;
        }

        // Show confirmation dialog with actual bounds info
        final shouldProceed = await _showDownloadConfirmation(noBuildings);
        if (!shouldProceed) return;

        print('Proceeding with download using bounds: $finalBounds');
        await _downloadOfflineTiles();
      } catch (e) {
        print('Error in download area: $e');
        if (!mounted) return;
        NotifierService.showMessage(
          context,
          message: 'Error checking building count: $e',
          type: MessageType.error,
        );
      }
    } else {
      print('ERROR: Download bounds is null!');
      NotifierService.showMessage(
        context,
        message: 'Error: Could not calculate download bounds',
        type: MessageType.error,
      );
    }
  }

  /// Show confirmation dialog with download details
  Future<bool> _showDownloadConfirmation(int buildingCount) async {
    if (!mounted) return false;

    // Calculate total tiles
    int totalTiles = 0;
    for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
      final bounds = _calculateTileBounds(_downloadBounds!, zoom);
      totalTiles += (bounds['maxX']! - bounds['minX']! + 1) *
          (bounds['maxY']! - bounds['minY']! + 1);
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Download'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Download Details:'),
            const SizedBox(height: 8),
            Text('• Buildings: $buildingCount'),
            Text('• Total tiles: $totalTiles'),
            Text('• Zoom levels: $_minZoom - $_maxZoom'),
            const SizedBox(height: 12),
            if (_actualTileAlignedBounds != null) ...[
              Text('Actual coverage area:'),
              Text(
                  '• North: ${_actualTileAlignedBounds!.north.toStringAsFixed(6)}'),
              Text(
                  '• South: ${_actualTileAlignedBounds!.south.toStringAsFixed(6)}'),
              Text(
                  '• West: ${_actualTileAlignedBounds!.west.toStringAsFixed(6)}'),
              Text(
                  '• East: ${_actualTileAlignedBounds!.east.toStringAsFixed(6)}'),
              const SizedBox(height: 8),
              const Text(
                'Note: The actual download area is aligned to tile boundaries and may be slightly larger than the visual selection.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Download'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  String _getRelativePreviewPath(String fullPath, String basePath) {
    if (fullPath.contains('/tiles/')) {
      final parts = fullPath.split('/tiles/');
      if (parts.length > 1) {
        return parts[1];
      }
    }

    final pathParts = fullPath.split('/');
    if (pathParts.length >= 3) {
      final fileName = pathParts.last;
      final xFolder = pathParts[pathParts.length - 2];
      final zoomFolder = pathParts[pathParts.length - 3];

      if (int.tryParse(zoomFolder) != null &&
          int.tryParse(xFolder) != null &&
          fileName.endsWith('.png')) {
        return '$zoomFolder/$xFolder/$fileName';
      }
    }

    return '';
  }

  Future<void> _downloadAll(int downloadId) async {
    final buildingRepository = sl<BuildingRepository>();
    final entranceRepository = sl<EntranceRepository>();
    final dwellingRepository = sl<DwellingRepository>();
    final userService = sl<UserService>();

    NotifierService.showMessage(
      context,
      message: 'Building download started with exact tile bounds',
      type: MessageType.info,
    );

    try {
      // CRITICAL: Use the exact same bounds that are used for tile downloading
      // This ensures perfect consistency between map tiles and building data

      print('=== BUILDING DOWNLOAD DEBUG ===');
      print('Using bounds: $_downloadBounds');
      print('North: ${_downloadBounds!.north}');
      print('South: ${_downloadBounds!.south}');
      print('West: ${_downloadBounds!.west}');
      print('East: ${_downloadBounds!.east}');

      // Verify these are the tile-aligned bounds
      if (_actualTileAlignedBounds != null) {
        final boundsMatch =
            _downloadBounds!.north == _actualTileAlignedBounds!.north &&
                _downloadBounds!.south == _actualTileAlignedBounds!.south &&
                _downloadBounds!.west == _actualTileAlignedBounds!.west &&
                _downloadBounds!.east == _actualTileAlignedBounds!.east;
        print('Bounds match tile-aligned bounds: $boundsMatch');
      }

      var buildings = await buildingRepository.getBuildings(
        _downloadBounds!,
        AppConfig.minZoomDownload,
        userService.userInfo!.municipality,
        true,
      );

      print('Buildings found: ${buildings.length}');

      // Log some building coordinates for verification
      if (buildings.isNotEmpty) {
        for (int i = 0; i < math.min(3, buildings.length); i++) {
          print('Building ${i + 1} location: ${buildings[i].toString()}');
        }
      }

      var buildingsDao = buildings.toDriftBuildingList(downloadId);
      await buildingRepository.insertBuildings(buildingsDao);

      List<String> buildingIds =
          buildings.map((entity) => entity.globalId!).toList();

      NotifierService.showMessage(
        context,
        message: 'Buildings inserted: ${buildings.length}',
        type: MessageType.info,
      );

      List<EntranceEntity> entrances =
          await entranceRepository.getEntrances(buildingIds);
      print('Entrances found: ${entrances.length}');

      var entrancesDao = entrances.toDriftEntranceList(downloadId);
      await entranceRepository.insertEntrances(entrancesDao);

      List<String> entrancesIds =
          entrances.map((entity) => entity.globalId!).toList();
      List<DwellingEntity> dwellings =
          await dwellingRepository.getDwellingsByEntrancesList(entrancesIds);
      print('Dwellings found: ${dwellings.length}');

      var dwellingsDao = dwellings.toDriftDwellingList(downloadId);
      await dwellingRepository.insertDwellings(dwellingsDao);

      NotifierService.showMessage(
        context,
        message:
            'Data download complete - Buildings: ${buildings.length}, Entrances: ${entrances.length}, Dwellings: ${dwellings.length}',
        type: MessageType.success,
      );

      print('=== BUILDING DOWNLOAD COMPLETE ===');
    } catch (e, stack) {
      print('Building download error: $e');
      print('Stack trace: $stack');
      NotifierService.showMessage(
        context,
        message: "Building download error: $e",
        type: MessageType.error,
      );
    }
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

      final downloadUseCase = sl<DownloadRepository>();
      final downloadId = await downloadUseCase.insertDownload();

      if (!mounted) return;

      NotifierService.showMessage(
        context,
        message: "Download ID: $downloadId",
        type: MessageType.info,
      );

      await _downloadAll(downloadId);

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String offlineMapPath =
          '${appDocDir.path}/offline_maps/$downloadId';

      await Directory(offlineMapPath).create(recursive: true);

      // Calculate total tiles for progress tracking
      int totalTiles = 0;
      List<Map<String, dynamic>> allTiles = [];

      for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
        final bounds = _calculateTileBounds(_downloadBounds!, zoom);
        for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
          for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
            allTiles.add({
              'zoom': zoom,
              'x': x,
              'y': y,
              'url': 'https://a.tile.openstreetmap.org/$zoom/$x/$y.png',
              'path': '$offlineMapPath/tiles/$zoom/$x/$y.png',
            });
            totalTiles++;
          }
        }
      }

      print('=== TILE DOWNLOAD START ===');
      print('Total tiles to download: $totalTiles');
      print('Zoom levels: $_minZoom to $_maxZoom');

      String? previewTilePath;
      int downloadedTiles = 0;
      int failedTiles = 0;

      // Progress tracking
      void updateProgress() {
        setState(() {
          _downloadProgress = (downloadedTiles + failedTiles) / totalTiles;
        });
      }

      // Download tiles in parallel with controlled concurrency
      await _downloadTilesInParallel(
        allTiles,
        onTileDownloaded: (tilePath, isPreview) {
          downloadedTiles++;
          if (previewTilePath == null || isPreview) {
            previewTilePath = tilePath;
          }
          updateProgress();
        },
        onTileFailed: (tileInfo, error) {
          failedTiles++;
          print(
              'Failed to download tile ${tileInfo['zoom']}/${tileInfo['x']}/${tileInfo['y']}: $error');
          updateProgress();
        },
      );

      print('=== TILE DOWNLOAD COMPLETE ===');
      print('Successfully downloaded: $downloadedTiles tiles');
      print('Failed downloads: $failedTiles tiles');

      // Save metadata with actual bounds used
      final metadata = {
        'sessionId': downloadId,
        'name':
            'Map ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        'location': 'Tirana, Albania',
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
        'actualBounds': _actualTileAlignedBounds != null
            ? {
                'northWest': {
                  'lat': _actualTileAlignedBounds!.northWest.latitude,
                  'lng': _actualTileAlignedBounds!.northWest.longitude,
                },
                'southEast': {
                  'lat': _actualTileAlignedBounds!.southEast.latitude,
                  'lng': _actualTileAlignedBounds!.southEast.longitude,
                },
              }
            : null,
        'zoomLevels': {
          'min': _minZoom,
          'max': _maxZoom,
        },
        'center': {
          'lat': _mapController.camera.center.latitude,
          'lng': _mapController.camera.center.longitude,
        },
        'totalTiles': downloadedTiles,
        'failedTiles': failedTiles,
        'previewTile': previewTilePath != null
            ? _getRelativePreviewPath(previewTilePath!, offlineMapPath)
            : null,
        'downloadStats': {
          'totalRequested': totalTiles,
          'successful': downloadedTiles,
          'failed': failedTiles,
          'successRate': totalTiles > 0
              ? (downloadedTiles / totalTiles * 100).toStringAsFixed(1)
              : '0',
        },
      };

      final metadataFile = File('$offlineMapPath/metadata.json');
      await metadataFile.writeAsString(jsonEncode(metadata));

      if (!mounted) return;

      final successRate = totalTiles > 0
          ? (downloadedTiles / totalTiles * 100).toStringAsFixed(1)
          : '0';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Offline map downloaded! $downloadedTiles/$totalTiles tiles ($successRate% success)'),
          backgroundColor: failedTiles == 0 ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Tile download error: $e');
      if (mounted) {
        NotifierService.showMessage(
          context,
          message: 'Error downloading offline map: $e',
          type: MessageType.error,
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    }
  }

  /// Download tiles in parallel with controlled concurrency
  Future<void> _downloadTilesInParallel(
    List<Map<String, dynamic>> tiles, {
    required void Function(String tilePath, bool isPreview) onTileDownloaded,
    required void Function(Map<String, dynamic> tileInfo, String error)
        onTileFailed,
    int maxConcurrency =
        6, // Limit concurrent downloads to avoid overwhelming the server
  }) async {
    // Create Dio instance with optimized settings for parallel downloads
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': '${AppConfig.appName}/${AppConfig.version}',
        'Accept': 'image/png,image/*,*/*',
        'Accept-Encoding': 'gzip, deflate',
      },
    ));

    // Process tiles in batches to control concurrency
    for (int i = 0; i < tiles.length; i += maxConcurrency) {
      final batch = tiles.skip(i).take(maxConcurrency).toList();

      // Download batch in parallel
      final futures = batch.map((tile) => _downloadSingleTile(dio, tile));
      final results = await Future.wait(futures, eagerError: false);

      // Process results
      for (int j = 0; j < results.length; j++) {
        final tile = batch[j];
        final result = results[j];

        if (result['success']) {
          final isPreview = tile['zoom'] == 13 ||
              (tile['zoom'] == _minZoom && tile['x'] == 0 && tile['y'] == 0);
          onTileDownloaded(result['path'], isPreview);
        } else {
          onTileFailed(tile, result['error']);
        }
      }

      // Small delay between batches to be respectful to the server
      if (i + maxConcurrency < tiles.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    dio.close();
  }

  /// Download a single tile with error handling
  Future<Map<String, dynamic>> _downloadSingleTile(
    Dio dio,
    Map<String, dynamic> tile,
  ) async {
    try {
      final String tilePath = tile['path'];
      final String tileUrl = tile['url'];

      // Create directory if needed
      final directory = Directory(tilePath).parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Download the tile
      await dio.download(tileUrl, tilePath);

      return {
        'success': true,
        'path': tilePath,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'path': tile['path'],
      };
    }
  }

// FIXED: More precise tile bounds calculation with proper coordinate handling
  Map<String, int> _calculateTileBounds(LatLngBounds bounds, int zoom) {
    // Ensure we're working with properly ordered bounds
    final double north = math.max(bounds.north, bounds.south);
    final double south = math.min(bounds.north, bounds.south);
    final double east = math.max(bounds.east, bounds.west);
    final double west = math.min(bounds.east, bounds.west);

    // More precise tile coordinate calculation
    final double zoomFactor = math.pow(2.0, zoom).toDouble();

    // Calculate tile coordinates for west/north (top-left)
    final double westTileX = ((west + 180.0) / 360.0) * zoomFactor;
    final double northLatRad = north * math.pi / 180.0;
    final double northTileY = (1.0 -
            math.log(math.tan(northLatRad) + 1.0 / math.cos(northLatRad)) /
                math.pi) *
        zoomFactor /
        2.0;

    // Calculate tile coordinates for east/south (bottom-right)
    final double eastTileX = ((east + 180.0) / 360.0) * zoomFactor;
    final double southLatRad = south * math.pi / 180.0;
    final double southTileY = (1.0 -
            math.log(math.tan(southLatRad) + 1.0 / math.cos(southLatRad)) /
                math.pi) *
        zoomFactor /
        2.0;

    // Floor/ceil to ensure we cover the entire area
    return {
      'minX': westTileX.floor(),
      'maxX': eastTileX.floor(),
      'minY': northTileY.floor(),
      'maxY': southTileY.floor(),
    };
  }

  /// Debug method to check what's currently visible and what would be downloaded
  void _debugCurrentView() async {
    _calculateActualDownloadBounds();

    final buildingRepository = sl<BuildingRepository>();
    final userService = sl<UserService>();

    if (_downloadBounds != null) {
      try {
        // Test building count with current bounds
        final buildingCount = await buildingRepository.buildingService
            .getBuildingsCount(
                _downloadBounds!, userService.userInfo!.municipality);

        // Test actual building retrieval
        final buildings = await buildingRepository.getBuildings(
          _downloadBounds!,
          AppConfig.minZoomDownload,
          userService.userInfo!.municipality,
          true,
        );

        print('=== DEBUG CURRENT VIEW ===');
        print('Current zoom: $_currentZoom');
        print('Download bounds: $_downloadBounds');
        print('Building count from service: $buildingCount');
        print('Actual buildings retrieved: ${buildings.length}');

        if (buildings.isNotEmpty) {
          print('Sample buildings:');
          for (int i = 0; i < math.min(5, buildings.length); i++) {
            final building = buildings[i];
            // Assuming building has latitude/longitude properties
            print(
                '  Building $i: ID=${building.globalId}, Location=${building.toString()}');
          }
        }

        // Calculate tile information
        final middleZoom = (_minZoom + _maxZoom) ~/ 2;
        final tileBounds = _calculateTileBounds(_downloadBounds!, middleZoom);
        print('Tile bounds at zoom $middleZoom: $tileBounds');

        // Show dialog with debug info
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Debug Info'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Zoom: ${_currentZoom.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Text('Download Bounds:'),
                    Text(
                        '  North: ${_downloadBounds!.north.toStringAsFixed(6)}'),
                    Text(
                        '  South: ${_downloadBounds!.south.toStringAsFixed(6)}'),
                    Text('  West: ${_downloadBounds!.west.toStringAsFixed(6)}'),
                    Text('  East: ${_downloadBounds!.east.toStringAsFixed(6)}'),
                    const SizedBox(height: 8),
                    Text(
                        'Buildings: $buildingCount (count) / ${buildings.length} (retrieved)'),
                    const SizedBox(height: 8),
                    Text('Tile Bounds (zoom $middleZoom):'),
                    Text('  X: ${tileBounds['minX']} to ${tileBounds['maxX']}'),
                    Text('  Y: ${tileBounds['minY']} to ${tileBounds['maxY']}'),
                    if (buildings.length != buildingCount) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.orange.withValues(alpha: 0.1),
                        child: const Text(
                          'WARNING: Building count mismatch! This suggests an issue with the building query or bounds.',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Debug error: $e');
        if (mounted) {
          NotifierService.showMessage(
            context,
            message: 'Debug error: $e',
            type: MessageType.error,
          );
        }
      }
    }
  }

  /// Get polygon points for the actual download bounds to display on map
  List<LatLng> _getActualBoundsPolygon() {
    if (_actualTileAlignedBounds == null) return [];

    return [
      _actualTileAlignedBounds!.northWest,
      LatLng(_actualTileAlignedBounds!.north, _actualTileAlignedBounds!.east),
      _actualTileAlignedBounds!.southEast,
      LatLng(_actualTileAlignedBounds!.south, _actualTileAlignedBounds!.west),
      _actualTileAlignedBounds!.northWest, // Close the polygon
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Map Downloader'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          // Enhanced action buttons
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _calculateActualDownloadBounds();
              _showDownloadConfirmation(0); // Show info dialog
            },
            tooltip: 'Show download info',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _debugCurrentView,
            tooltip: 'Debug current view',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(41.3275, 19.8189),
              initialZoom: AppConfig.initZoom,
              onPositionChanged: (position, _) {
                setState(() {
                  _currentZoom = position.zoom;
                });
                // Recalculate bounds when map moves
                if (_currentZoom >= AppConfig.minZoomDownload) {
                  _calculateActualDownloadBounds();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              // Show actual download bounds as polygon overlay
              if (_actualTileAlignedBounds != null &&
                  _currentZoom >= AppConfig.minZoomDownload)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _getActualBoundsPolygon(),
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderColor: Colors.cyan,
                      borderStrokeWidth: 2.0,
                    ),
                  ],
                ),
            ],
          ),

          // Zoom level indicator
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Zoom: ${_currentZoom.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Fixed visual selection square (reference only)
          if (_currentZoom >= AppConfig.minZoomDownload)
            Center(
              child: IgnorePointer(
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.withValues(alpha: 0.1),
                  ),
                  child: const Center(
                    child: Text(
                      'Visual\nSelection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Zoom in to level ${AppConfig.minZoomDownload} or higher to download',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

          // Legend
          if (_currentZoom >= AppConfig.minZoomDownload)
            Positioned(
              top: 70,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 2),
                            color: Colors.orange.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Visual Selection',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyan, width: 2),
                            color: Colors.cyan.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Actual Download Area',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
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
                    padding: const EdgeInsets.all(16),
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
                        const SizedBox(height: 8),
                        Text(
                          '${(_downloadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                FloatingActionButton.extended(
                  onPressed: (_isDownloading ||
                          _currentZoom < AppConfig.minZoomDownload)
                      ? null
                      : _downloadArea,
                  backgroundColor: (_isDownloading ||
                          _currentZoom < AppConfig.minZoomDownload)
                      ? Colors.grey
                      : Colors.cyan,
                  foregroundColor: Colors.white,
                  icon: Icon(
                      _isDownloading ? Icons.hourglass_empty : Icons.download),
                  label: Text(_isDownloading
                      ? 'Downloading...'
                      : _currentZoom < AppConfig.minZoomDownload
                          ? 'Zoom in to Download'
                          : 'Download'),
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

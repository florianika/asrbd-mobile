import 'dart:math';

import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/mapper/download_mappers.dart';
import 'package:asrdb/data/mapper/dwelling_mapper.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/download_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class OfflineMap extends StatefulWidget {
  const OfflineMap({super.key});

  @override
  State<OfflineMap> createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  final MapController _mapController = MapController();
  final TextEditingController _nameController = TextEditingController();

  final double squareSize = 200;
  double _currentZoom = 19;
  bool _mapReady = false;

  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = '';

  LatLngBounds? _downloadBounds;

  void _calculateDownloadBounds() {
    try {
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

      // Ensure proper bounds ordering
      final north = math.max(nw.latitude, se.latitude);
      final south = math.min(nw.latitude, se.latitude);
      final east = math.max(nw.longitude, se.longitude);
      final west = math.min(nw.longitude, se.longitude);

      _downloadBounds = LatLngBounds.fromPoints([
        LatLng(north, west), // Northwest
        LatLng(south, east), // Southeast
      ]);

      print('=== DOWNLOAD BOUNDS ===');
      print('North: $north, South: $south, East: $east, West: $west');
    } catch (e) {
      print('Error calculating download bounds: $e');
      _downloadBounds = null;
    }
  }

  void _downloadArea() async {
    // Calculate the download bounds based on current map position
    _calculateDownloadBounds();

    if (_downloadBounds == null) {
      NotifierService.showMessage(
        context,
        message: 'Error: Could not calculate download bounds',
        type: MessageType.error,
      );
      return;
    }

    final buildingRepository = sl<BuildingRepository>();
    final userService = sl<UserService>();

    try {
      // Check building count
      final noBuildings = await buildingRepository.buildingService
          .getBuildingsCount(
              _downloadBounds!, userService.userInfo!.municipality);

      print('Building count in bounds: $noBuildings');

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

      // Show confirmation dialog with name input
      final result = await _showDownloadDialog(noBuildings);
      if (result == null ||
          result['proceed'] != true ||
          result['name'] == null ||
          result['name'].toString().trim().isEmpty) {
        return;
      }

      final downloadName = result['name'].toString().trim();
      print('Proceeding with download: $downloadName');

      await _downloadData(downloadName);
    } catch (e) {
      print('Error in download area: $e');
      if (!mounted) return;
      NotifierService.showMessage(
        context,
        message: 'Error checking building count: $e',
        type: MessageType.error,
      );
    }
  }

  /// Show download dialog with name input and confirmation
  Future<Map<String, dynamic>?> _showDownloadDialog(int buildingCount) async {
    if (!mounted) return null;

    _nameController.clear();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Download Offline Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Download Details:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('• Buildings: $buildingCount'),
            Text(
                '• Area: ${_downloadBounds!.north.toStringAsFixed(6)}, ${_downloadBounds!.west.toStringAsFixed(6)} to ${_downloadBounds!.south.toStringAsFixed(6)}, ${_downloadBounds!.east.toStringAsFixed(6)}'),
            const SizedBox(height: 16),
            const Text('Download Name:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter a name for this download',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            const Text(
              'This name will be used to identify the downloaded data.',
              style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) {
                NotifierService.showMessage(
                  context,
                  message: 'Please enter a name for the download',
                  type: MessageType.warning,
                );
                return;
              }
              Navigator.of(context).pop({
                'proceed': true,
                'name': name,
              });
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );

    return result;
  }

  Future<void> _downloadData(String downloadName) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadStatus = 'Initializing download...';
    });

    try {
      final userService = sl<UserService>();
      final downloadUseCase = sl<DownloadRepository>();
      var downloadInfo = DownloadEntity(
        areaName: downloadName,
        boundsNorthWestLat: _downloadBounds!.northWest.latitude,
        boundsNorthWestLng: _downloadBounds!.northWest.longitude,
        boundsSouthEastLng: _downloadBounds!.southEast.longitude,
        boundsSouthEastLat: _downloadBounds!.southEast.latitude,
        centerLat: _mapController.camera.center.latitude,
        centerLng: _mapController.camera.center.longitude,
        municipalityId: userService.userInfo!.municipality,
        email: userService.userInfo!.email,
        userId: -1, //int.parse(userService.userInfo!.nameId),
      );

      final downloadId =
          await downloadUseCase.insertDownload(downloadInfo.toDriftDownload());

      if (!mounted) return;

      // Download buildings, entrances, and dwellings
      await _downloadAllData(downloadId, downloadName);

      // Save metadata
      // await _saveMetadata(downloadId, downloadName);

      if (!mounted) return;

      NotifierService.showMessage(
        context,
        message: 'Download completed successfully: $downloadName',
        type: MessageType.success,
      );
    } catch (e) {
      if (mounted) {
        NotifierService.showMessage(
          context,
          message: 'Error downloading data: $e',
          type: MessageType.error,
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
        _downloadStatus = '';
      });
    }
  }

  Future<void> _downloadAllData(int downloadId, String downloadName) async {
    final buildingRepository = sl<BuildingRepository>();
    final entranceRepository = sl<EntranceRepository>();
    final dwellingRepository = sl<DwellingRepository>();
    final userService = sl<UserService>();

    // Download buildings
    var buildings = await buildingRepository.getBuildingsOnline(
      _downloadBounds!,
      AppConfig.minZoomDownload,
      userService.userInfo!.municipality,
    );

    var buildingsDao = buildings.toDriftBuildingList(downloadId);
    await buildingRepository.insertBuildings(buildingsDao);

    // // Download entrances
    List<String> buildingIds =
        buildings.map((entity) => entity.globalId!).toList();
    List<EntranceEntity> entrances =
        await entranceRepository.getEntrances(buildingIds);

    var entrancesDao = entrances.toDriftEntranceList(downloadId);
    await entranceRepository.insertEntrances(entrancesDao);

    // // Download dwellings
    List<String> entrancesIds =
        entrances.map((entity) => entity.globalId!).toList();
    List<DwellingEntity> dwellings =
        await dwellingRepository.getDwellingsByEntrancesList(entrancesIds);

    var dwellingsDao = dwellings.toDriftDwellingList(downloadId);
    await dwellingRepository.insertDwellings(dwellingsDao);
  }

  /// Get polygon points for the download bounds to display on map
  List<LatLng> _getBoundsPolygon() {
    try {
      if (!_mapReady) return [];

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

      return [
        nw, // Northwest
        LatLng(nw.latitude, se.longitude), // Northeast
        se, // Southeast
        LatLng(se.latitude, nw.longitude), // Southwest
        nw, // Close the polygon
      ];
    } catch (e) {
      print('Error calculating bounds polygon: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tileProvider = FMTCTileProvider(
      stores: const {'mapStore': BrowseStoreStrategy.readUpdateCreate},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Data Downloader'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              if (_currentZoom >= AppConfig.minZoomDownload) {
                // Calculate bounds for info display only
                _calculateDownloadBounds();
                if (_downloadBounds != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Download Area Info'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Current Zoom: ${_currentZoom.toStringAsFixed(2)}'),
                          const SizedBox(height: 8),
                          const Text('Download Area:'),
                          Text(
                              'North: ${_downloadBounds!.north.toStringAsFixed(6)}'),
                          Text(
                              'South: ${_downloadBounds!.south.toStringAsFixed(6)}'),
                          Text(
                              'East: ${_downloadBounds!.east.toStringAsFixed(6)}'),
                          Text(
                              'West: ${_downloadBounds!.west.toStringAsFixed(6)}'),
                        ],
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
              } else {
                NotifierService.showMessage(
                  context,
                  message:
                      'Zoom in to level ${AppConfig.minZoomDownload} or higher to see download area',
                  type: MessageType.info,
                );
              }
            },
            tooltip: 'Show download info',
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
              onMapReady: () {
                setState(() {
                  _mapReady = true;
                });
              },
              onPositionChanged: (position, _) {
                setState(() {
                  _currentZoom = position.zoom;
                });
                // Don't calculate bounds here - only update zoom level
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.asrdb.al',
                tileProvider: tileProvider,
              ),
              // Show download area as polygon overlay that updates dynamically
              if (_mapReady && _currentZoom >= AppConfig.minZoomDownload)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _getBoundsPolygon(),
                      color: Colors.cyan.withValues(alpha: .2),
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

          // Show message when zoom is too low
          if (_currentZoom < AppConfig.minZoomDownload)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Zoom in to level ${AppConfig.minZoomDownload} or higher to select download area',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
                        if (_downloadStatus.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _downloadStatus,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                          : 'Download Data'),
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

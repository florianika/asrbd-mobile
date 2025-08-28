import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DownloadedMapsViewer extends StatefulWidget {
  @override
  State<DownloadedMapsViewer> createState() => _DownloadedMapsViewerState();
}

class _DownloadedMapsViewerState extends State<DownloadedMapsViewer> {
  List<DownloadedMap> _downloadedMaps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedMaps();
  }

  Future<void> _loadDownloadedMaps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String offlineMapsPath = '${appDocDir.path}/offline_maps';
      final Directory offlineMapsDir = Directory(offlineMapsPath);

      if (!await offlineMapsDir.exists()) {
        setState(() {
          _downloadedMaps = [];
          _isLoading = false;
        });
        return;
      }

      List<DownloadedMap> maps = [];

      // Get all session directories
      await for (FileSystemEntity sessionEntity in offlineMapsDir.list()) {
        if (sessionEntity is Directory) {
          try {
            // Try to load metadata for this session
            final metadataFile = File('${sessionEntity.path}/metadata.json');
            if (await metadataFile.exists()) {
              final metadataContent = await metadataFile.readAsString();
              final metadata = jsonDecode(metadataContent);

              // Calculate actual file size by scanning tiles
              int actualSize = 0;
              final tilesDir = Directory('${sessionEntity.path}/tiles');
              if (await tilesDir.exists()) {
                await for (FileSystemEntity entity
                    in tilesDir.list(recursive: true)) {
                  if (entity is File && entity.path.endsWith('.png')) {
                    final stats = await entity.stat();
                    actualSize += stats.size;
                  }
                }
              }

              // Construct preview tile path
              String? previewTilePath;
              if (metadata['previewTile'] != null) {
                previewTilePath =
                    '${sessionEntity.path}/tiles/${metadata['previewTile']}';
                // Verify the preview file exists
                if (!await File(previewTilePath).exists()) {
                  previewTilePath = null;
                }
              }

              final map = DownloadedMap(
                sessionId: metadata['sessionId'].toString(),
                name: metadata['name'],
                location: metadata['location'],
                totalTiles: metadata['totalTiles'],
                sizeInBytes: actualSize,
                zoomLevels: List<int>.generate(
                  metadata['zoomLevels']['max'] -
                      metadata['zoomLevels']['min'] +
                      1,
                  (index) => metadata['zoomLevels']['min'] + index,
                ),
                downloadDate: DateTime.parse(metadata['downloadDate']),
                lastAccessed: DateTime.parse(
                    metadata['downloadDate']), // For now, same as download date
                previewTilePath: previewTilePath,
                bounds: LatLngBounds.fromPoints([
                  LatLng(metadata['bounds']['northWest']['lat'],
                      metadata['bounds']['northWest']['lng']),
                  LatLng(metadata['bounds']['southEast']['lat'],
                      metadata['bounds']['southEast']['lng']),
                ]),
                center: LatLng(
                  metadata['center']['lat'],
                  metadata['center']['lng'],
                ),
              );

              maps.add(map);
            }
          } catch (e) {
            print('Error loading map session ${sessionEntity.path}: $e');
            // Continue with other sessions

            NotifierService.showMessage(
              context,
              message: 'Error loading map session ${sessionEntity.path}: $e',
              type: MessageType.error,
            );
          }
        }
      }

      // Sort maps by download date (newest first)
      maps.sort((a, b) => b.downloadDate.compareTo(a.downloadDate));

      setState(() {
        _downloadedMaps = maps;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading downloaded maps: $e');
      setState(() {
        _downloadedMaps = [];
        _isLoading = false;
      });
    }
  }

  // Handle legacy map data (old structure without metadata)
  Future<DownloadedMap?> _analyzeLegacyMapData(Directory mapDir) async {
    try {
      int totalTiles = 0;
      int totalSize = 0;
      List<int> zoomLevels = [];
      DateTime? oldestDate;
      DateTime? newestDate;
      String? previewTilePath;

      // Check if this looks like the old structure (zoom folders directly in session folder)
      bool hasDirectZoomFolders = false;
      await for (FileSystemEntity entity in mapDir.list()) {
        if (entity is Directory) {
          final String name = entity.path.split('/').last;
          if (int.tryParse(name) != null) {
            hasDirectZoomFolders = true;
            break;
          }
        }
      }

      if (!hasDirectZoomFolders) return null;

      // Analyze legacy structure
      await for (FileSystemEntity zoomEntity in mapDir.list()) {
        if (zoomEntity is Directory) {
          final String zoomStr = zoomEntity.path.split('/').last;
          final int? zoom = int.tryParse(zoomStr);

          if (zoom != null) {
            zoomLevels.add(zoom);

            await for (FileSystemEntity xDir in zoomEntity.list()) {
              if (xDir is Directory) {
                await for (FileSystemEntity tileFile in xDir.list()) {
                  if (tileFile is File && tileFile.path.endsWith('.png')) {
                    totalTiles++;

                    if (previewTilePath == null || zoom == 13) {
                      previewTilePath = tileFile.path;
                    }

                    final FileStat stats = await tileFile.stat();
                    totalSize += stats.size;

                    if (oldestDate == null ||
                        stats.modified.isBefore(oldestDate)) {
                      oldestDate = stats.modified;
                    }
                    if (newestDate == null ||
                        stats.modified.isAfter(newestDate)) {
                      newestDate = stats.modified;
                    }
                  }
                }
              }
            }
          }
        }
      }

      if (totalTiles > 0) {
        zoomLevels.sort();
        return DownloadedMap(
          sessionId: 'legacy_${mapDir.path.split('/').last}',
          name: 'Legacy Map',
          location: 'Unknown Location',
          totalTiles: totalTiles,
          sizeInBytes: totalSize,
          zoomLevels: zoomLevels,
          downloadDate: newestDate ?? DateTime.now(),
          lastAccessed: oldestDate ?? DateTime.now(),
          previewTilePath: previewTilePath,
          bounds: null, // No bounds info for legacy maps
        );
      }
    } catch (e) {
      print('Error analyzing legacy map data: $e');
    }
    return null;
  }

  Future<void> _applyMap(int index) async {
    final map = _downloadedMaps[index];
    StorageService storageService = sl<StorageService>();

    if (!mounted) return;

    // Point to the correct tiles folder for this specific downloaded map
    context.read<TileCubit>().setOfflineSession(map.sessionId, map.center!);

    // Save the correct sessionId
    storageService.saveString(
      boxName: HiveBoxes.offlineMap,
      key: "map",
      value: map.sessionId,
    );
  }

  Future<void> _deleteMap(int index) async {
    final map = _downloadedMaps[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Map'),
          content: Text(
              'Are you sure you want to delete "${map.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String sessionPath =
            '${appDocDir.path}/offline_maps/${map.sessionId}';
        final Directory sessionDir = Directory(sessionPath);

        if (await sessionDir.exists()) {
          await sessionDir.delete(recursive: true);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Map "${map.name}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _loadDownloadedMaps(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting map: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Maps'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDownloadedMaps,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.cyan),
                  SizedBox(height: 16),
                  Text('Loading downloaded maps...'),
                ],
              ),
            )
          : _downloadedMaps.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No offline maps found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Download some maps to see them here',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDownloadedMaps,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _downloadedMaps.length,
                    itemBuilder: (context, index) {
                      final map = _downloadedMaps[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Map preview
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: map.previewTilePath != null
                                          ? Image.file(
                                              File(map.previewTilePath!),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey[400],
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.map_outlined,
                                                color: Colors.grey[400],
                                                size: 32,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Map info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          map.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          map.location,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.cyan
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.cyan
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Text(
                                                '${map.totalTiles} tiles',
                                                style: TextStyle(
                                                  color: Colors.cyan[700],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Text(
                                                _formatFileSize(
                                                    map.sizeInBytes),
                                                style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Options menu
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteMap(index);
                                      } else {
                                        _applyMap(index);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'apply',
                                        child: Row(
                                          children: [
                                            Icon(Icons.check,
                                                color: Colors.green),
                                            SizedBox(width: 8),
                                            Text('Apply'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.zoom_in,
                                      'Zoom Levels',
                                      '${map.zoomLevels.first}-${map.zoomLevels.last}',
                                      true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.download_done,
                                      'Downloaded',
                                      _formatDate(map.downloadDate),
                                      true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildInfoItem(
      IconData icon, String label, String value, bool isTablet) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 20 : 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isTablet ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DownloadedMap {
  final String sessionId;
  final String name;
  final String location;
  final int totalTiles;
  final int sizeInBytes;
  final List<int> zoomLevels;
  final DateTime downloadDate;
  final DateTime lastAccessed;
  final String? previewTilePath;
  final LatLngBounds? bounds;
  final LatLng? center;

  DownloadedMap({
    required this.sessionId,
    required this.name,
    required this.location,
    required this.totalTiles,
    required this.sizeInBytes,
    required this.zoomLevels,
    required this.downloadDate,
    required this.lastAccessed,
    this.previewTilePath,
    this.bounds,
    this.center,
  });
}

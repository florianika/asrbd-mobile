import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/routing/route_manager.dart';
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
  List<DownloadedData> _downloadedData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedData();
  }

  Future<void> _loadDownloadedData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String offlineDataPath = '${appDocDir.path}/offline_data';
      final Directory offlineDataDir = Directory(offlineDataPath);

      if (!await offlineDataDir.exists()) {
        setState(() {
          _downloadedData = [];
          _isLoading = false;
        });
        return;
      }

      List<DownloadedData> dataList = [];

      // Get all session directories
      await for (FileSystemEntity sessionEntity in offlineDataDir.list()) {
        if (sessionEntity is Directory) {
          try {
            // Try to load metadata for this session
            final metadataFile = File('${sessionEntity.path}/metadata.json');
            if (await metadataFile.exists()) {
              final metadataContent = await metadataFile.readAsString();
              final metadata = jsonDecode(metadataContent);

              // Calculate directory size
              int totalSize = 0;
              await for (FileSystemEntity entity
                  in sessionEntity.list(recursive: true)) {
                if (entity is File) {
                  final stats = await entity.stat();
                  totalSize += stats.size;
                }
              }

              final downloadedData = DownloadedData(
                sessionId: metadata['sessionId'].toString(),
                name: metadata['name'] ?? 'Unnamed Download',
                location: metadata['location'] ?? 'Unknown Location',
                buildingCount: 0, // Will be updated from database if needed
                sizeInBytes: totalSize,
                downloadDate: DateTime.parse(metadata['downloadDate']),
                userMunicipalityId: metadata['user']?['municipalityId'],
                userEmail: metadata['user']?['email'],
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

              dataList.add(downloadedData);
            }
          } catch (e) {
            print('Error loading data session ${sessionEntity.path}: $e');

            NotifierService.showMessage(
              context,
              message:
                  'Error loading data session: ${sessionEntity.path.split('/').last}',
              type: MessageType.warning,
            );
          }
        }
      }

      // Sort data by download date (newest first)
      dataList.sort((a, b) => b.downloadDate.compareTo(a.downloadDate));

      setState(() {
        _downloadedData = dataList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading downloaded data: $e');
      setState(() {
        _downloadedData = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _applyMap(int index) async {
    final data = _downloadedData[index];
    StorageService storageService = sl<StorageService>();

    if (!mounted) return;

    await context.read<TileCubit>().setOfflineSession(data.sessionId,
        data.center, data.bounds, data.userId, data.userMunicipalityId,);

    // Save the correct sessionId
    await storageService.saveString(
      boxName: HiveBoxes.offlineMap,
      key: "map",
      value: data.sessionId,
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, RouteManager.homeRoute);
  }

  Future<void> _deleteData(int index) async {
    final data = _downloadedData[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Downloaded Data'),
          content: Text(
              'Are you sure you want to delete "${data.name}"?\n\nThis will permanently remove all buildings, entrances, and dwellings data for this area. This action cannot be undone.'),
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
            '${appDocDir.path}/offline_data/${data.sessionId}';
        final Directory sessionDir = Directory(sessionPath);

        if (await sessionDir.exists()) {
          await sessionDir.delete(recursive: true);
        }

        // TODO: Also remove data from local database if needed
        // This would require calling the repository methods to delete buildings, entrances, dwellings by sessionId

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data "${data.name}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _loadDownloadedData(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting data: $e'),
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
        title: Text('Downloaded Areas'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDownloadedData,
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
                  Text('Loading downloaded areas...'),
                ],
              ),
            )
          : _downloadedData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No offline areas found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Download some areas to see them here',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDownloadedData,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _downloadedData.length,
                    itemBuilder: (context, index) {
                      final data = _downloadedData[index];
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
                                  // Area icon
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.cyan.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.cyan.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_city,
                                          color: Colors.cyan[600],
                                          size: 32,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'AREA',
                                          style: TextStyle(
                                            color: Colors.cyan[600],
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Area info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          data.location,
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
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.business,
                                                    size: 12,
                                                    color: Colors.orange[700],
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    '${data.buildingCount} buildings',
                                                    style: TextStyle(
                                                      color: Colors.orange[700],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
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
                                                    data.sizeInBytes),
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
                                        _deleteData(index);
                                      } else if (value == 'apply') {
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
                                            Text('Apply Area'),
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
                                      Icons.calendar_today,
                                      'Downloaded',
                                      _formatDate(data.downloadDate),
                                      true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.location_on,
                                      'Coordinates',
                                      '${data.center.latitude.toStringAsFixed(4)}, ${data.center.longitude.toStringAsFixed(4)}',
                                      true,
                                    ),
                                  ),
                                ],
                              ),
                              if (data.userEmail != null ||
                                  data.userMunicipalityId != null) ...[
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (data.userEmail != null)
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.person,
                                          'User',
                                          data.userEmail!,
                                          true,
                                        ),
                                      ),
                                    if (data.userMunicipalityId != null)
                                      Expanded(
                                        child: _buildInfoItem(
                                          Icons.location_city,
                                          'Municipality',
                                          data.userMunicipalityId!.toString(),
                                          true,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
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

class DownloadedData {
  final String sessionId;
  final String name;
  final String location;
  final int buildingCount;
  final int sizeInBytes;
  final DateTime downloadDate;
  final int? userMunicipalityId;
  final String? userEmail;
  final int? userId;
  final LatLngBounds bounds;
  final LatLng center;

  DownloadedData({
    required this.sessionId,
    required this.name,
    required this.location,
    required this.buildingCount,
    required this.sizeInBytes,
    required this.downloadDate,
    this.userMunicipalityId,
    this.userId,
    this.userEmail,
    required this.bounds,
    required this.center,
  });
}

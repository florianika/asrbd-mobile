import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/download_mappers.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/offline/domain/building_sync_usecases.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class DownloadedMapsViewer extends StatefulWidget {
  const DownloadedMapsViewer({super.key});

  @override
  State<DownloadedMapsViewer> createState() => _DownloadedMapsViewerState();
}

class _DownloadedMapsViewerState extends State<DownloadedMapsViewer> {
  List<Download> _downloadedData = [];
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
      final downloadRespository = sl<DownloadRepository>();
      _downloadedData = await downloadRespository.getAllDownloads();

      setState(() {
        _downloadedData.sort((a, b) => b.createdDate.compareTo(a.createdDate));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _downloadedData = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _applyMap(int index) async {
    final data = _downloadedData[index];
    await context.read<TileCubit>().setOfflineSession(data.toEntity());

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteManager.homeRoute);
  }

  Future<void> _syncMap(int index) async {
    final data = _downloadedData[index];

    // Show sync in progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Synchronizing "${data.areaName}"...'),
            ],
          ),
        );
      },
    );

    try {
      final buildingSyncUseCase = sl<BuildingSyncUseCases>();

      List<BuildingEntity> buildings =
          await buildingSyncUseCase.getBuildingsToSync(data.id);
      await buildingSyncUseCase.syncBuildings(buildings);

      //TODO: steps below
      //1. get entrances to sync
      //2. sync entrances

      //3. get dwellings to sync
      //4. sync dwellings

      //5. delete all unchanged buildings, entrances and dwellings
      //6. fetch all data from esri again and insert locally to have latest version

      Navigator.of(context).pop(); // Close progress dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data "${buildings.length}" synchronized successfully'),
          backgroundColor: Colors.green,
        ),
      );

      _loadDownloadedData(); // Refresh the list
    } catch (e) {
      Navigator.of(context).pop(); // Close progress dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error synchronizing data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteData(int index) async {
    final data = _downloadedData[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Downloaded Data'),
          content: Text(
              'Are you sure you want to delete "${data.areaName}"?\n\nThis will permanently remove all buildings, entrances, and dwellings data for this area. This action cannot be undone.'),
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
        // TODO: Implement delete logic here

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Mock function to determine if there are pending items
  bool _hasPendingItems(Download data) {
    // TODO: Replace with actual logic to check for pending sync items
    return data.id % 3 == 0; // Mock: every 3rd item has pending sync
  }

  // Mock function to get last sync date
  DateTime? _getLastSyncDate(Download data) {
    // TODO: Replace with actual logic to get last sync date
    return data.createdDate
        .subtract(Duration(hours: 2)); // Mock: 2 hours after download
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey[900]!,
              Colors.blueGrey[800]!,
              Colors.blueGrey[700]!,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Downloaded Areas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _loadDownloadedData,
                        tooltip: 'Refresh',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.cyan[300],
                                    strokeWidth: 3,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading downloaded areas...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : _downloadedData.isEmpty
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.location_city_outlined,
                                      size: 64,
                                      color: Colors.cyan[300],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'No offline areas found',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Download some areas to see them here',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadDownloadedData,
                            color: Colors.cyan[300],
                            backgroundColor: Colors.blueGrey[800],
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _downloadedData.length,
                              itemBuilder: (context, index) {
                                final data = _downloadedData[index];
                                final hasPending = _hasPendingItems(data);
                                final lastSync = _getLastSyncDate(data);

                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.cyan
                                                            .withOpacity(0.3),
                                                        Colors.blue
                                                            .withOpacity(0.3),
                                                      ],
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.cyan
                                                          .withOpacity(0.5),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.location_city,
                                                    color: Colors.cyan[300],
                                                    size: 28,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.areaName,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 0.3,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child:
                                                      PopupMenuButton<String>(
                                                    onSelected: (value) {
                                                      if (value == 'delete') {
                                                        _deleteData(index);
                                                      } else if (value ==
                                                          'apply') {
                                                        _applyMap(index);
                                                      } else if (value ==
                                                          'sync') {
                                                        _syncMap(index);
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        [
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'apply',
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.check,
                                                                color: Colors
                                                                    .green,
                                                                size: 20),
                                                            SizedBox(width: 8),
                                                            Text('Apply Area'),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'sync',
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.sync,
                                                                color:
                                                                    Colors.blue,
                                                                size: 20),
                                                            SizedBox(width: 8),
                                                            Text('Synchronize'),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'delete',
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                                size: 20),
                                                            SizedBox(width: 8),
                                                            Text('Delete'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (hasPending) ...[
                                              SizedBox(height: 8),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.orange
                                                        .withOpacity(0.5),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.sync_problem,
                                                      size: 14,
                                                      color: Colors.orange[300],
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Has items pending synchronization',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.orange[300],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            SizedBox(height: 12),
                                            Container(
                                              height: 1,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.white
                                                        .withOpacity(0.2),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    Icons.calendar_today,
                                                    'Downloaded',
                                                    _formatDate(
                                                        data.createdDate),
                                                    true,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    Icons.person,
                                                    'User',
                                                    data.email,
                                                    true,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildInfoItem(
                                                    Icons.sync,
                                                    'Last Sync',
                                                    lastSync != null
                                                        ? _formatDate(lastSync)
                                                        : 'Never',
                                                    true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
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
          size: isTablet ? 16 : 14,
          color: Colors.white.withOpacity(0.7),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
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

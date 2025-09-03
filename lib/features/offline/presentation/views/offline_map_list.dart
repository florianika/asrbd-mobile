import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/download_mappers.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class DownloadedMapsViewer extends StatefulWidget {
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
        // final Directory appDocDir = await getApplicationDocumentsDirectory();
        // final String sessionPath = '${appDocDir.path}/offline_data/${data.id}';
        // final Directory sessionDir = Directory(sessionPath);

        // if (await sessionDir.exists()) {
        //   await sessionDir.delete(recursive: true);
        // }

        // // TODO: Also remove data from local database if needed
        // // This would require calling the repository methods to delete buildings, entrances, dwellings by sessionId

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Data "${data.name}" deleted successfully'),
        //     backgroundColor: Colors.green,
        //   ),
        // );

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
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
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
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.cyan
                                                            .withOpacity(0.3),
                                                        blurRadius: 15,
                                                        offset: Offset(0, 5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.location_city,
                                                        color: Colors.cyan[300],
                                                        size: 32,
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'AREA',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.cyan[300],
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.areaName,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .orange
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .orange
                                                                    .withOpacity(
                                                                        0.4),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .business,
                                                                  size: 14,
                                                                  color: Colors
                                                                          .orange[
                                                                      300],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green
                                                                    .withOpacity(
                                                                        0.4),
                                                                width: 1,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                                            12),
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
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white,
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
                                                                    .green),
                                                            SizedBox(width: 8),
                                                            Text('Apply Area'),
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
                                                                    Colors.red),
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
                                            SizedBox(height: 20),
                                            Container(
                                              height: 1,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.white
                                                        .withOpacity(0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
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
                                              ],
                                            ),
                                            ...[
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
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
                                                      Icons.location_city,
                                                      'Municipality',
                                                      data.municipalityId
                                                          .toString(),
                                                      true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
          size: isTablet ? 20 : 16,
          color: Colors.white.withOpacity(0.7),
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
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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

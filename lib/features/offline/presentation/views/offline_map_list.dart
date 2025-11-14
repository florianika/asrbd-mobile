import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/download_mappers.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/features/offline/domain/sync_usecases.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
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
  final userService = sl<UserService>();
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
    final loadingCubit = context.read<LoadingCubit>();
    final data = _downloadedData[index];
    loadingCubit.show();
    // Show sync in progress
    final syncUseCase = sl<SyncUseCases>();

    try {
      List<BuildingEntity> buildings =
          await syncUseCase.getBuildingsToSync(data.id);
      await syncUseCase.syncBuildings(buildings, data.id);

      List<EntranceEntity> entrances =
          await syncUseCase.getEntrancesToSync(data.id);

      await syncUseCase.syncEntrances(entrances, data.id);

      List<DwellingEntity> dwellings =
          await syncUseCase.getDwellingsToSync(data.id);
      await syncUseCase.syncDwellings(dwellings, data.id);

      await syncUseCase.deleteUnmodifiedObjects(data.id);

      final bounds = LatLngBounds(
        LatLng(data.boundsNorthWestLat!, data.boundsNorthWestLng!),
        LatLng(data.boundsSouthEastLat!, data.boundsSouthEastLng!),
      );

      await syncUseCase.downloadAllData(data.id, data.municipalityId, bounds);

      syncUseCase.updateSyncStatus(data.id, true); // Mark as successful

      if (!mounted) return;

      NotifierService.showMessage(context,
          message:
              'Synchronization completed successfully. ${buildings.length} buildings, ${entrances.length} entrances, and ${dwellings.length} dwellings synchronized.',
          type: MessageType.success);

      _loadDownloadedData(); // Refresh the list
    } catch (e) {
      syncUseCase.updateSyncStatus(data.id, false);
      if (!mounted) return;

      NotifierService.showMessage(context,
          message: e.toString(), type: MessageType.error);
    } finally {
      loadingCubit.hide();
    }
  }

  Future<void> _deleteData(int index) async {
    final data = _downloadedData[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(localizations.translate(Keys.deleteDownloadedData)),
          content: Text(localizations
              .translate(Keys.deleteConfirmMessage)
              .replaceAll('{areaName}', data.areaName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.translate(Keys.cancel)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(localizations.translate(Keys.delete)),
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
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations
                .translate(Keys.errorDeletingData)
                .replaceAll('{error}', e.toString())),
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

  Widget _buildSyncStatusIcon(Download data) {
    // Check if sync has ever been attempted
    if (data.lastSyncDate == null) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.sync_disabled,
          size: 16,
          color: Colors.grey[400],
        ),
      );
    }

    // Show sync status based on syncSuccess value
    if (data.syncSuccess == true) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.check_circle,
          size: 16,
          color: Colors.green[400],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.red.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.error_outline,
          size: 16,
          color: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoadingCubit, LoadingState>(
        builder: (context, state) {
          return LoadingIndicator(
            isLoading: state.isLoading,
            child: Container(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
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
                            onPressed: () {
                              final authState = context.read<AuthCubit>().state;
                              if (authState is AuthAuthenticated) {
                                Navigator.of(context).pop();
                              } else {
                                if (_downloadedData.isEmpty) {
                                  Navigator.pushReplacementNamed(
                                      context, RouteManager.loginRoute);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Perdoruesi: ${userService.userInfo?.uniqueName} ${userService.userInfo?.familyName}\n',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.8),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate(Keys.downloadedAreas),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: _loadDownloadedData,
                              tooltip: AppLocalizations.of(context)
                                  .translate(Keys.refresh),
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
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
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
                                          AppLocalizations.of(context)
                                              .translate(
                                                  Keys.loadingDownloadedAreas),
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
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.cyan
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.location_city_outlined,
                                            size: 64,
                                            color: Colors.cyan[300],
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(Keys.noOfflineAreas),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  Keys.downloadSomeAreas),
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.8),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: _downloadedData.length,
                                    itemBuilder: (context, index) {
                                      final data = _downloadedData[index];
                                      final hasPending = _hasPendingItems(data);
                                      final lastSync = data.lastSyncDate;

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Colors.cyan
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3),
                                                              Colors.blue
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3),
                                                            ],
                                                          ),
                                                          border: Border.all(
                                                            color: Colors.cyan
                                                                .withValues(
                                                                    alpha: 0.5),
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          Icons.location_city,
                                                          color:
                                                              Colors.cyan[300],
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.3,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(height: 4),
                                                            _buildSyncStatusIcon(
                                                                data),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                    alpha: 0.2),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: PopupMenuButton<
                                                            String>(
                                                          onSelected: (value) {
                                                            if (value ==
                                                                'delete') {
                                                              _deleteData(
                                                                  index);
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
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  [
                                                            PopupMenuItem<
                                                                String>(
                                                              value: 'apply',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 20),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          Keys.applyArea)),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<
                                                                String>(
                                                              value: 'sync',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .sync,
                                                                      color: Colors
                                                                          .blue,
                                                                      size: 20),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          Keys.synchronize)),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem<
                                                                String>(
                                                              value: 'delete',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 20),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          Keys.delete)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange
                                                            .withValues(
                                                                alpha: 0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: Colors.orange
                                                              .withValues(
                                                                  alpha: 0.5),
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
                                                            color: Colors
                                                                .orange[300],
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(Keys
                                                                    .hasPendingSync),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .orange[300],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                              .withValues(
                                                                  alpha: 0.2),
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
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(Keys
                                                                  .downloaded),
                                                          _formatDate(
                                                              data.createdDate),
                                                          true,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: _buildInfoItem(
                                                          Icons.person,
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  Keys.user),
                                                          data.email,
                                                          true,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: _buildInfoItem(
                                                          Icons.sync,
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(Keys
                                                                  .lastSync),
                                                          lastSync != null
                                                              ? _formatDate(
                                                                  lastSync)
                                                              : AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(Keys
                                                                      .never),
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
        },
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
          color: Colors.white.withValues(alpha: 0.7),
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
                  color: Colors.white.withValues(alpha: 0.7),
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

import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/cubit/location_accuracy_cubit.dart';
import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/models/field_work_status.dart';

class MapAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  const MapAppBar({super.key, this.title});

  @override
  State<MapAppBar> createState() => _MapAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MapAppBarState extends State<MapAppBar> {
  bool? _previousFieldWorkStatus;
  final userService = sl<UserService>();

  bool _shouldShowEnvironmentBadge(String environment) {
    final normalized = environment.trim().toLowerCase();
    return normalized.isNotEmpty &&
        normalized != 'production' &&
        normalized != 'prod';
  }

  Widget _buildEnvironmentBadge(String environment) {
    final label = environment.trim().toUpperCase();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade700.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldWorkCubit, FieldWorkStatus>(
      builder: (context, fieldWorkStatus) {
        final isActive = fieldWorkStatus.isFieldworkTime;

        // Detect change in field work status
        if (_previousFieldWorkStatus != null &&
            _previousFieldWorkStatus != isActive) {}
        _previousFieldWorkStatus = isActive;

        return AppBar(
          title: BlocConsumer<TileCubit, TileState>(
            listener: (context, state) {},
            builder: (context, state) {
              return RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)
                              .translate(Keys.userDisplayName)
                              .replaceAll(
                                  '{name}',
                                  '${userService.userInfo?.uniqueName} ${userService.userInfo?.familyName}') +
                          '\n',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)
                          .translate(Keys.modeLabel),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: state.isOffline
                          ? AppLocalizations.of(context)
                              .translate(Keys.modeOffline)
                          : AppLocalizations.of(context)
                              .translate(Keys.modeOnline),
                      style: TextStyle(
                        fontSize: 14,
                        color: state.isOffline ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            if (_shouldShowEnvironmentBadge(AppConfig.environment))
              _buildEnvironmentBadge(AppConfig.environment),
            BlocBuilder<LocationAccuracyCubit, LocationAccuracyState>(
              builder: (context, locationState) {
                if (locationState is LocationAccuracyUpdated) {
                  final isAccurate = locationState.isAccurate;
                  final color = isAccurate ? Colors.green : Colors.orange;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.95),
                          color.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${locationState.accuracy.toStringAsFixed(1)}m',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (locationState is LocationAccuracyError) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.gps_off,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'GPS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Badge(
              child: IconButton(
                icon: Icon(
                  fieldWorkStatus.inError
                      ? Icons.warning
                      : isActive
                          ? Icons.check_circle
                          : Icons.cancel,
                  size: 25,
                  color: fieldWorkStatus.inError
                      ? Colors.orange
                      : isActive
                          ? Colors.green
                          : Colors.red,
                ),
                onPressed: () {
                  _showFieldWorkStatusModal(context, fieldWorkStatus);
                },
              ),
            ),
            BlocBuilder<TileCubit, TileState>(
              builder: (context, tileState) {
                if (tileState.isOffline) {
                  return const SizedBox.shrink();
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.layers, size: 25),
                      onSelected: (String result) {
                        context.read<TileCubit>().setBasemap(result == "terrain"
                            ? AppConfig.basemapTerrainUrl
                            : result == "esriSatellite"
                                ? AppConfig.basemapEsriSatelliteUrl
                                : AppConfig.basemapAsigSatellite2025Url);
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'terrain',
                          child: Row(
                            children: [
                              Icon(Icons.terrain, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)
                                  .translate(Keys.basemapTerrain)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'esriSatellite',
                          child: Row(
                            children: [
                              Icon(Icons.satellite, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)
                                  .translate(Keys.basemapEsriSatellite)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'asigSatellite2025',
                          child: Row(
                            children: [
                              Icon(Icons.satellite, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)
                                  .translate(Keys.basemapAsig2025)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.download, size: 25),
                      onSelected: (String result) => Navigator.pushNamed(
                          context, RouteManager.downloadMapRoute),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(Icons.download, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)
                                  .translate(Keys.download)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showFieldWorkStatusModal(
      BuildContext context, FieldWorkStatus fieldWorkStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                fieldWorkStatus.inError
                    ? Icons.warning
                    : fieldWorkStatus.isFieldworkTime
                        ? Icons.check_circle
                        : Icons.cancel,
                color: fieldWorkStatus.inError
                    ? Colors.orange
                    : fieldWorkStatus.isFieldworkTime
                        ? Colors.green
                        : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                fieldWorkStatus.inError
                    ? AppLocalizations.of(context)
                        .translate(Keys.problemOccurred)
                    : fieldWorkStatus.isFieldworkTime
                        ? AppLocalizations.of(context)
                            .translate(Keys.fieldWorkActive)
                        : AppLocalizations.of(context)
                            .translate(Keys.fieldWorkInactive),
                style: TextStyle(
                  color: fieldWorkStatus.inError
                      ? Colors.orange
                      : fieldWorkStatus.isFieldworkTime
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: fieldWorkStatus.inError
              ? Text(
                  fieldWorkStatus.msg!,
                  style: TextStyle(fontSize: 16),
                )
              : fieldWorkStatus.isFieldworkTime
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            'ID:', fieldWorkStatus.fieldworkId.toString()),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            AppLocalizations.of(context).translate(Keys.status),
                            AppLocalizations.of(context)
                                .translate(Keys.active)),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            AppLocalizations.of(context)
                                .translate(Keys.started),
                            fieldWorkStatus.startTime ?? 'N/A'),
                        // const SizedBox(height: 8),
                        // _buildDetailRow('Location:', fieldWorkStatus.location ?? 'N/A'),
                      ],
                    )
                  : Text(
                      AppLocalizations.of(context)
                          .translate(Keys.fieldWorkNotOpenedMessage),
                      style: const TextStyle(fontSize: 16),
                    ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).translate(Keys.close)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

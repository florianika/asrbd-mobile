import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/models/field_work_status.dart';

class MapAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MapAppBar({super.key});

  @override
  State<MapAppBar> createState() => _MapAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MapAppBarState extends State<MapAppBar> {
  bool? _previousFieldWorkStatus;
  bool _showBadge = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldWorkCubit, FieldWorkStatus>(
      builder: (context, fieldWorkStatus) {
        final isActive = fieldWorkStatus.isFieldworkTime;
        final msg = fieldWorkStatus.msg ?? '';

        // Detect change in field work status
        if (_previousFieldWorkStatus != null &&
            _previousFieldWorkStatus != isActive) {
          _showBadge = true;
        }
        _previousFieldWorkStatus = isActive;

        final hasStatusUpdate = _showBadge;

        return AppBar(
          title: BlocBuilder<AttributesCubit, AttributesState>(
            builder: (context, state) {
              return Text(
                'ASRDB - $msg',
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
          actions: [
            Badge(
              isLabelVisible: hasStatusUpdate,
              label: const Text('1'),
              child: IconButton(
                icon: Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  size: 25,
                  color: isActive ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _showBadge = false;
                  });
                  _showFieldWorkStatusModal(context, fieldWorkStatus);
                },
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.layers, size: 25),
              onSelected: (String result) {
                // Handle basemap selection
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                  value: 'satellite',
                  child: Row(
                    children: [
                      Icon(Icons.satellite, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)
                          .translate(Keys.basemapSatellite)),
                    ],
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.download, size: 25),
              onSelected: (String result) =>
                  Navigator.pushNamed(context, RouteManager.downloadMapRoute),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                fieldWorkStatus.isFieldworkTime
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                    fieldWorkStatus.isFieldworkTime ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                fieldWorkStatus.isFieldworkTime
                    ? 'Field Work Active'
                    : 'Field Work Inactive',
                style: TextStyle(
                  color: fieldWorkStatus.isFieldworkTime
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: fieldWorkStatus.isFieldworkTime
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        'ID:', fieldWorkStatus.fieldworkId.toString()),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status:', 'Active'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Started:', fieldWorkStatus.startTime ?? 'N/A'),
                    // const SizedBox(height: 8),
                    // _buildDetailRow('Location:', fieldWorkStatus.location ?? 'N/A'),
                  ],
                )
              : const Text(
                  'Field work is not opened yet. Please start a field work session to view details.',
                  style: TextStyle(fontSize: 16),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/markers/municipality_marker.dart';
import 'package:asrdb/core/widgets/side_menu/side_menu.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

enum BldReviewFilter {
  all,
  needsReview, // BldReview IN (5,6)
}

class TiranaImageOverlayWidget extends StatefulWidget {
  const TiranaImageOverlayWidget({Key? key}) : super(key: key);

  @override
  State<TiranaImageOverlayWidget> createState() =>
      _TiranaImageOverlayWidgetState();
}

class _TiranaImageOverlayWidgetState extends State<TiranaImageOverlayWidget> {
  final StorageService _storage = StorageService();
  final Dio _dio = Dio();
  final MapController _mapController = MapController();
  LatLng? _userLocation;

  final String serverBase =
      'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/MapServer/export';

  final double fallbackXmin = 19.779516666666666;
  final double fallbackYmin = 41.293399999999998;
  final double fallbackXmax = 19.852583333333332;
  final double fallbackYmax = 41.348199999999999;

  final int bldReviewRiHapur = 5;
  final int bldReviewKerkohetRishikim = 6;

  final userService = sl<UserService>();
  int bldMunicipality = 0;

  // default to needsReview as previous behavior showed review states
  BldReviewFilter _currentFilter = BldReviewFilter.needsReview;

  Future<_ImageResponse?>? _imageFuture;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _imageFuture = fetchImageResponse(_currentFilter);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  String buildExportUrl(
    BldReviewFilter filter, {
    required double xmin,
    required double ymin,
    required double xmax,
    required double ymax,
  }) {
    final bbox = '$xmin,$ymin,$xmax,$ymax';
    bldMunicipality = userService.userInfo!.municipality;

    final List<Map<String, dynamic>> dynamicLayersList = [];

    if (filter == BldReviewFilter.all) {
      // All buildings in municipality, dark grey
      dynamicLayersList.add({
        "id": 1,
        "source": {"type": "mapLayer", "mapLayerId": 1},
        "definitionExpression": "BldMunicipality = $bldMunicipality",
        "drawingInfo": {
          "renderer": {
            "type": "simple",
            "symbol": {
              "type": "esriSFS",
              "style": "esriSFSSolid",
              "color": [80, 80, 80, 255], // dark grey
              "outline": {
                "type": "esriSLS",
                "style": "esriSLSSolid",
                "color": [60, 60, 60, 255],
                "width": 1
              }
            }
          }
        }
      });
    } else {
      // Only BldReview 5 or 6 in municipality, red
      dynamicLayersList.add({
        "id": 1,
        "source": {"type": "mapLayer", "mapLayerId": 1},
        "definitionExpression":
            "BldReview IN ($bldReviewRiHapur,$bldReviewKerkohetRishikim) AND BldMunicipality = $bldMunicipality",
        "drawingInfo": {
          "renderer": {
            "type": "simple",
            "symbol": {
              "type": "esriSFS",
              "style": "esriSFSSolid",
              "color": [190, 34, 18, 255], // red
              "outline": {
                "type": "esriSLS",
                "style": "esriSLSSolid",
                "color": [190, 34, 18, 255],
                "width": 1
              }
            }
          }
        }
      });
    }

    final dynamicLayers = Uri.encodeComponent(jsonEncode(dynamicLayersList));

    String layerDefsRaw;
    if (filter == BldReviewFilter.all) {
      layerDefsRaw = '1:BldMunicipality = $bldMunicipality';
    } else {
      layerDefsRaw =
          '1:BldReview IN ($bldReviewRiHapur,$bldReviewKerkohetRishikim) AND BldMunicipality = $bldMunicipality';
    }
    final layerDefs = Uri.encodeComponent(layerDefsRaw);

    final params = [
      'bbox=$bbox',
      'bboxSR=4326',
      'imageSR=4326',
      'size=1600,1200',
      'layers=show:1',
      'format=png32',
      'transparent=true',
      'dynamicLayers=$dynamicLayers',
      'layerDefs=$layerDefs',
      'f=json',
    ];

    return '$serverBase?${params.join('&')}';
  }

  List<double> _currentVisibleBbox() {
    try {
      final bounds = _mapController.camera.visibleBounds;
      final sw = bounds.southWest;
      final ne = bounds.northEast;
      return [sw.longitude, sw.latitude, ne.longitude, ne.latitude];
    } catch (_) {}
    return [fallbackXmin, fallbackYmin, fallbackXmax, fallbackYmax];
  }

  Future<_ImageResponse?> fetchImageResponse(BldReviewFilter filter) async {
    final bboxList = _currentVisibleBbox();
    final url = buildExportUrl(
      filter,
      xmin: bboxList[0],
      ymin: bboxList[1],
      xmax: bboxList[2],
      ymax: bboxList[3],
    );

    try {
      final token = await _storage.getString(key: StorageKeys.esriAccessToken);

      final res = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      dynamic raw = res.data;
      if (raw is String) {
        try {
          raw = jsonDecode(raw);
        } catch (_) {
          final snippet = raw.length > 400 ? raw.substring(0, 400) : raw;
          throw Exception(
              'Invalid response structure: server returned a plain string. Snippet: $snippet');
        }
      }

      if (raw is! Map<String, dynamic>) {
        throw Exception(
            'Invalid response structure: expected JSON object but got ${raw.runtimeType}');
      }

      final Map<String, dynamic> data = raw;

      final hrefCandidates = <String>[
        'href',
        'url',
        'image',
        'imageUrl',
        'outputUrl',
        'mapUrl'
      ];
      String? href;
      for (final k in hrefCandidates) {
        if (data.containsKey(k) && data[k] is String) {
          href = data[k] as String;
          break;
        }
      }

      if (href == null) {
        if (data['images'] is List && (data['images'] as List).isNotEmpty) {
          final first = (data['images'] as List).first;
          if (first is Map && first['href'] is String) href = first['href'];
          if (first is Map && first['url'] is String) href ??= first['url'];
        }
        if (href == null && data['exportedMap'] is Map) {
          final em = data['exportedMap'] as Map;
          if (em['href'] is String) href = em['href'] as String;
          if (em['url'] is String) href = em['url'] as String;
        }
      }

      final extentObj = (data['extent'] is Map)
          ? data['extent'] as Map<String, dynamic>
          : null;

      if (href == null || extentObj == null) {
        final excerpt =
            jsonEncode(data).substring(0, min(1000, jsonEncode(data).length));
        throw Exception(
            'Invalid response structure: missing href or extent. Response snippet: $excerpt');
      }

      final xmin = (extentObj['xmin'] as num).toDouble();
      final ymin = (extentObj['ymin'] as num).toDouble();
      final xmax = (extentObj['xmax'] as num).toDouble();
      final ymax = (extentObj['ymax'] as num).toDouble();

      return _ImageResponse(
        href: href,
        width: (data['width'] as num?)?.toInt(),
        height: (data['height'] as num?)?.toInt(),
        xmin: xmin,
        ymin: ymin,
        xmax: xmax,
        ymax: ymax,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onMapReady() async {
    final location = await LocationService.getCurrentLocation();

    setState(() {
      _userLocation = location;
    });
  }

  void _onMapPositionChanged(MapCamera position, bool hasGesture) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _imageFuture = fetchImageResponse(_currentFilter));
    });
  }

  void _onFilterChanged(BldReviewFilter filter) {
    if (filter == _currentFilter) return;
    setState(() {
      _currentFilter = filter;
      _imageFuture = fetchImageResponse(_currentFilter);
    });
  }

  Widget _buildFilterButton(String label, BldReviewFilter filter, Color color) {
    final isSelected = _currentFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, RouteManager.homeRoute);
              },
              tooltip: localizations.translate(Keys.backToMap),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(localizations.translate(Keys.buildingReviewTitle)),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterButton(
                    localizations.translate(Keys.buildingReviewFilterAll),
                    BldReviewFilter.all,
                    const Color(0xFF1E88E5)), // vibrant blue
                const SizedBox(width: 6),
                _buildFilterButton(
                    localizations
                        .translate(Keys.buildingReviewFilterNeedsReview),
                    BldReviewFilter.needsReview, const Color(0xFFBE2212)),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: FutureBuilder<_ImageResponse?>(
          future: _imageFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue[600]!,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate(Keys.loadingMapOverlay),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snap.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.translate(Keys.errorLoadingOverlay),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snap.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final data = snap.data;
            if (data == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizations.translate(Keys.noImageDataAvailable),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            final overlayBounds = LatLngBounds(
              LatLng(data.ymin, data.xmin),
              LatLng(data.ymax, data.xmax),
            );
            final center = LatLng(
              (data.ymin + data.ymax) / 2,
              (data.xmin + data.xmax) / 2,
            );

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15,
                onPositionChanged: _onMapPositionChanged,
                onMapReady: _onMapReady,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                OverlayImageLayer(
                  overlayImages: [
                    OverlayImage(
                      imageProvider: NetworkImage(data.href),
                      bounds: overlayBounds,
                      opacity: 1.0,
                    ),
                  ],
                ),
                if (_userLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                BlocConsumer<TileCubit, TileState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return MunicipalityMarker(
                        isOffline: state.isOffline,
                        municipalityId: state.download?.municipalityId,
                      );
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ImageResponse {
  final String href;
  final int? width;
  final int? height;
  final double xmin;
  final double ymin;
  final double xmax;
  final double ymax;

  _ImageResponse({
    required this.href,
    this.width,
    this.height,
    required this.xmin,
    required this.ymin,
    required this.xmax,
    required this.ymax,
  });
}

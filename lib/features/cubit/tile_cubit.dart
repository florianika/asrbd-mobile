import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/csr/epsg_6870_csr.dart';
import 'package:asrdb/domain/entities/download_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

class TileState extends Equatable {
  final bool isOffline;
  final DownloadEntity? download;
  final String basemapUrl;
  final bool isSatellite;
  final String storeName;
  final Crs csr;
  final double maxZoom;
  final double initialZoom;

  const TileState({
    required this.isOffline,
    this.download,
    this.basemapUrl = AppConfig.basemapTerrainUrl,
    this.isSatellite = false,
    this.storeName = AppConfig.basemapTerrainUrl,
    this.csr = const Epsg3857(),
    this.maxZoom = AppConfig.maxZoom,
    this.initialZoom = AppConfig.initZoom,
  });

  TileState copyWith({
    bool? isOffline,
    DownloadEntity? download,
    String? basemapUrl,
    bool? isSatellite,
    String? storeName,
    Crs? csr,
    double? maxZoom,
    double? initialZoom,
  }) {
    return TileState(
      isOffline: isOffline ?? this.isOffline,
      download: download ?? this.download,
      basemapUrl: basemapUrl ?? this.basemapUrl,
      isSatellite: isSatellite ?? this.isSatellite,
      storeName: storeName ?? this.storeName,
      csr: csr ?? this.csr,
      maxZoom: maxZoom ?? this.maxZoom,
      initialZoom: initialZoom ?? this.initialZoom,
    );
  }

  @override
  List<Object?> get props => [
        isOffline,
        download,
        basemapUrl,
        isSatellite,
        storeName,
      ];
}

class TileCubit extends Cubit<TileState> {
  TileCubit()
      : super(TileState(
          isOffline: false,
          basemapUrl: AppConfig.basemapTerrainUrl,
          isSatellite: false,
          storeName: _getStoreName(AppConfig.basemapTerrainUrl),
        ));

  /// Set online mode with a specific basemap URL
  Future<void> setOnlineMode({
    required String url,
    bool isSatellite = false,
  }) async {
    emit(state.copyWith(
      isOffline: false,
      download: null,
      basemapUrl: url,
      isSatellite: isSatellite,
      storeName: _getStoreName(url),
    ));
  }

  /// Set offline mode with a specific session
  Future<void> setOfflineSession(DownloadEntity download) async {
    emit(state.copyWith(
      isOffline: true,
      download: download,
    ));
  }

  /// Update only the basemap (URL + satellite flag), keeping other state
  void setBasemap(String url) {
    emit(state.copyWith(
      basemapUrl: url,
      csr: url == AppConfig.basemapAsigSatellite2025Url
          ? Epsg6870Crs.crs
          : const Epsg3857(),
      isSatellite: url == AppConfig.basemapEsriSatelliteUrl ||
          url == AppConfig.basemapAsigSatellite2025Url,
      storeName: _getStoreName(url),
      maxZoom: url == AppConfig.basemapAsigSatellite2025Url
          ? Epsg6870Crs.maxZoom
          : AppConfig.maxZoom,
      initialZoom: url == AppConfig.basemapAsigSatellite2025Url
          ? AppConfig.initZoomAsig
          : AppConfig.initZoom,
    ));
  }

  bool get isOffline => state.isOffline;
  DownloadEntity? get download => state.download;
  String get basemapUrl => state.basemapUrl;
  bool get isSatellite => state.isSatellite;
  String get storeName => state.storeName;
  double get maxZoom => state.maxZoom;
  double get initZoom => state.initialZoom;

  /// Utility: derive a unique store name from basemap URL
  static String _getStoreName(String url) {
    if (url == AppConfig.basemapEsriSatelliteUrl) {
      return AppConfig.mapEsriSatelliteStoreName;
    } else if (url == AppConfig.basemapAsigSatellite2025Url) {
      return AppConfig.mapAsigSatellite2025StoreName;
    } else {
      return AppConfig.mapTerrainStoreName;
    }
  }
}

import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/domain/entities/download_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class TileState extends Equatable {
  final bool isOffline;
  final DownloadEntity? download;
  final String basemapUrl;
  final bool isSatellite;
  final String storeName;

  const TileState({
    required this.isOffline,
    this.download,
    this.basemapUrl = AppConfig.basemapTerrainUrl,
    this.isSatellite = false,
    this.storeName = AppConfig.basemapTerrainUrl,
  });

  TileState copyWith({
    bool? isOffline,
    DownloadEntity? download,
    String? basemapUrl,
    bool? isSatellite,
    String? storeName,
  }) {
    return TileState(
      isOffline: isOffline ?? this.isOffline,
      download: download ?? this.download,
      basemapUrl: basemapUrl ?? this.basemapUrl,
      isSatellite: isSatellite ?? this.isSatellite,
      storeName: storeName ?? this.storeName,
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
  Future<void> setBasemap(String url) async {
    emit(state.copyWith(
      basemapUrl: url,
      isSatellite: url == AppConfig.basemapSatelliteUrl,
      storeName: _getStoreName(url),
    ));
  }

  bool get isOffline => state.isOffline;
  DownloadEntity? get download => state.download;
  String get basemapUrl => state.basemapUrl;
  bool get isSatellite => state.isSatellite;
  String get storeName => state.storeName;

  /// Utility: derive a unique store name from basemap URL
  static String _getStoreName(String url) {
    if (url == AppConfig.basemapSatelliteUrl) {
      return AppConfig.mapSatelliteStoreName;
    } else {
      return AppConfig.mapTerrainStoreName;
    }
  }
}

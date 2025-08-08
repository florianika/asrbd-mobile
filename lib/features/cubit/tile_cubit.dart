import 'package:asrdb/core/services/tile_index_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TileState extends Equatable {
  final String path;
  final bool isOffline;
  final String? activeSessionId;
  final TileIndexService? indexService;

  const TileState({
    required this.path,
    required this.isOffline,
    this.activeSessionId,
    this.indexService,
  });

  @override
  List<Object?> get props => [path, isOffline, activeSessionId, indexService];
}

class TileCubit extends Cubit<TileState> {
  static const String _offlineMapsDirName = 'offline_maps';
  TileIndexService? _globalIndexService;

  TileCubit() : super(const TileState(path: '', isOffline: false)) {
    _initializeIndexService();
  }

  Future<void> _initializeIndexService() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String offlineMapsPath = '${appDocDir.path}/$_offlineMapsDirName';

      _globalIndexService = TileIndexService(offlineMapsPath);
    } catch (e) {
      print('Error initializing TileIndexService: $e');
    }
  }

  /// Set online mode with URL template path
  Future<void> setOnlineMode(String urlTemplate) async {
    _globalIndexService?.clear();

    emit(TileState(
      path: urlTemplate,
      isOffline: false,
      activeSessionId: null,
      indexService: null,
    ));
  }

  /// Set offline mode with a specific session
  Future<void> setOfflineSession(String sessionId) async {
    if (_globalIndexService == null) {
      await _initializeIndexService();
    }

    if (_globalIndexService == null) {
      print('Failed to initialize TileIndexService');
      return;
    }

    try {
      // Set the active session and preload tiles
      _globalIndexService!.setActiveSession(sessionId);
      await _globalIndexService!.preloadTiles();

      // Get the tiles path for this session
      final String? tilesPath = _globalIndexService!.activeTilePath;

      if (tilesPath != null) {
        emit(TileState(
          path: tilesPath,
          isOffline: true,
          activeSessionId: sessionId,
          indexService: _globalIndexService,
        ));

        print('Switched to offline session: $sessionId');
        print('Tiles path: $tilesPath');
        print('Available tiles: ${_globalIndexService!.tileCount}');
      } else {
        print('Failed to get tiles path for session: $sessionId');
      }
    } catch (e) {
      print('Error setting offline session: $e');
    }
  }

  /// Legacy method for backward compatibility
  @Deprecated('Use setOfflineSession() instead')
  Future<void> setPath(String path, {bool isOffline = false}) async {
    if (isOffline) {
      // Try to extract session ID from path
      final pathSegments = path.split('/');
      final tilesIndex = pathSegments.lastIndexOf('tiles');

      if (tilesIndex > 0) {
        final sessionId = pathSegments[tilesIndex - 1];
        await setOfflineSession(sessionId);
        return;
      }
    }

    // Fallback to old behavior for online mode
    emit(TileState(
      path: path,
      isOffline: isOffline,
      activeSessionId: null,
      indexService: null,
    ));
  }

  /// Get all available offline sessions
  Future<List<String>> getAvailableSessions() async {
    if (_globalIndexService == null) {
      await _initializeIndexService();
    }

    return _globalIndexService?.getAvailableSessions() ?? [];
  }

  /// Switch between different offline sessions
  Future<void> switchOfflineSession(String sessionId) async {
    if (state.isOffline) {
      await setOfflineSession(sessionId);
    } else {
      print('Not in offline mode. Use setOfflineSession() instead.');
    }
  }

  /// Check if a specific tile exists (only works in offline mode)
  bool hasTile(int z, int x, int y) {
    if (!state.isOffline || state.indexService == null) {
      return false;
    }
    return state.indexService!.hasTile(z, x, y);
  }

  /// Get tile file (only works in offline mode)
  File? getTileFile(int z, int x, int y) {
    if (!state.isOffline || state.indexService == null) {
      return null;
    }

    try {
      return state.indexService!.getFile(z, x, y);
    } catch (e) {
      print('Error getting tile file: $e');
      return null;
    }
  }

  /// Get available zoom levels for current offline session
  Set<int> get availableZoomLevels {
    if (!state.isOffline || state.indexService == null) {
      return {};
    }
    return state.indexService!.availableZoomLevels;
  }

  /// Get total tile count for current offline session
  int get tileCount {
    if (!state.isOffline || state.indexService == null) {
      return 0;
    }
    return state.indexService!.tileCount;
  }

  // Getters for backward compatibility
  String get path => state.path;
  bool get isOffline => state.isOffline;
  String? get activeSessionId => state.activeSessionId;
  TileIndexService? get indexService => state.indexService;

  @override
  Future<void> close() async {
    _globalIndexService?.clear();
    return super.close();
  }
}

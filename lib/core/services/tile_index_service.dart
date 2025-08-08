import 'dart:io';
import 'package:path/path.dart' as p;

class TileIndexService {
  final String offlineMapsDirPath;
  final Set<String> _availableTiles = {};
  String? _activeSessionId;
  String? _activeTilePath;

  TileIndexService(this.offlineMapsDirPath);

  /// Set the active session to use for tile operations
  void setActiveSession(String sessionId) {
    _activeSessionId = sessionId;
    _activeTilePath = p.join(offlineMapsDirPath, sessionId, 'tiles');
    _availableTiles.clear(); // Clear cache when switching sessions
  }

  /// Preload tiles from the currently active session
  Future<void> preloadTiles() async {
    if (_activeSessionId == null || _activeTilePath == null) {
      print('No active session set. Call setActiveSession() first.');
      return;
    }

    final dir = Directory(_activeTilePath!);
    if (!await dir.exists()) {
      print('Tiles directory does not exist: $_activeTilePath');
      return;
    }

    print('Preloading tiles from session: $_activeSessionId');
    print('Tiles path: $_activeTilePath');

    try {
      final files = await dir
          .list(recursive: true)
          .where((entity) => entity is File && entity.path.endsWith('.png'))
          .toList();

      print('Found ${files.length} tile files');

      for (final entity in files) {
        final relativePath = p.relative(entity.path, from: _activeTilePath!);
        final parts = p.split(relativePath);
        
        // Expected structure: z/x/y.png
        if (parts.length >= 3) {
          final z = parts[parts.length - 3];
          final x = parts[parts.length - 2];
          final y = parts[parts.length - 1].replaceAll('.png', '');
          
          // Validate that z, x, and y are numbers
          if (int.tryParse(z) != null && int.tryParse(x) != null && int.tryParse(y) != null) {
            _availableTiles.add('$z/$x/$y');
          }
        }
      }

      print('Indexed ${_availableTiles.length} tiles for session: $_activeSessionId');
      
      // Debug: Print some sample tiles
      if (_availableTiles.isNotEmpty) {
        final sampleTiles = _availableTiles.take(5).toList();
        print('Sample tiles: $sampleTiles');
      }
      
    } catch (e) {
      print('Error preloading tiles: $e');
    }
  }

  /// Preload tiles from all available sessions
  Future<void> preloadAllSessions() async {
    final offlineMapsDir = Directory(offlineMapsDirPath);
    if (!await offlineMapsDir.exists()) {
      print('Offline maps directory does not exist: $offlineMapsDirPath');
      return;
    }

    print('Scanning all sessions in: $offlineMapsDirPath');
    _availableTiles.clear();

    try {
      // Get all session directories
      await for (FileSystemEntity sessionEntity in offlineMapsDir.list()) {
        if (sessionEntity is Directory) {
          final sessionId = p.basename(sessionEntity.path);
          final tilesPath = p.join(sessionEntity.path, 'tiles');
          final tilesDir = Directory(tilesPath);

          if (await tilesDir.exists()) {
            print('Loading tiles from session: $sessionId');
            
            final files = await tilesDir
                .list(recursive: true)
                .where((entity) => entity is File && entity.path.endsWith('.png'))
                .toList();

            for (final entity in files) {
              final relativePath = p.relative(entity.path, from: tilesPath);
              final parts = p.split(relativePath);
              
              // Expected structure: z/x/y.png
              if (parts.length >= 3) {
                final z = parts[parts.length - 3];
                final x = parts[parts.length - 2];
                final y = parts[parts.length - 1].replaceAll('.png', '');
                
                // Validate that z, x, and y are numbers
                if (int.tryParse(z) != null && int.tryParse(x) != null && int.tryParse(y) != null) {
                  // Prefix with session ID to avoid conflicts between sessions
                  _availableTiles.add('$sessionId:$z/$x/$y');
                }
              }
            }
          }
        }
      }

      print('Total tiles indexed across all sessions: ${_availableTiles.length}');
      
    } catch (e) {
      print('Error preloading all sessions: $e');
    }
  }

  bool hasTile(int z, int x, int y) {
    if (_activeSessionId == null) {
      print('No active session set. Call setActiveSession() first.');
      return false;
    }

    final key = '$z/$x/$y';
    final hasIt = _availableTiles.contains(key);
    
    if (!hasIt) {
      // Debug logging for missing tiles
      print('Tile not found: $key in session: $_activeSessionId');
      if (_availableTiles.isEmpty) {
        print('No tiles indexed yet. Call preloadTiles() first.');
      }
    }
    return hasIt;
  }

  File getFile(int z, int x, int y) {
    if (_activeSessionId == null || _activeTilePath == null) {
      throw StateError('No active session set. Call setActiveSession() first.');
    }
    return File(p.join(_activeTilePath!, '$z', '$x', '$y.png'));
  }

  /// Get available sessions
  Future<List<String>> getAvailableSessions() async {
    final offlineMapsDir = Directory(offlineMapsDirPath);
    if (!await offlineMapsDir.exists()) {
      return [];
    }

    final sessions = <String>[];
    
    try {
      await for (FileSystemEntity sessionEntity in offlineMapsDir.list()) {
        if (sessionEntity is Directory) {
          final sessionId = p.basename(sessionEntity.path);
          final tilesDir = Directory(p.join(sessionEntity.path, 'tiles'));
          
          // Only include sessions that have a tiles directory
          if (await tilesDir.exists()) {
            sessions.add(sessionId);
          }
        }
      }
    } catch (e) {
      print('Error getting available sessions: $e');
    }

    return sessions;
  }

  // Helper method to get tile count for active session
  int get tileCount => _availableTiles.length;

  // Helper method to get available zoom levels for active session
  Set<int> get availableZoomLevels {
    return _availableTiles
        .map((tile) => int.tryParse(tile.split('/')[0]))
        .where((z) => z != null)
        .cast<int>()
        .toSet();
  }

  // Get current active session
  String? get activeSessionId => _activeSessionId;
  String? get activeTilePath => _activeTilePath;

  // Clear the cache
  void clear() {
    _availableTiles.clear();
    _activeSessionId = null;
    _activeTilePath = null;
  }
}
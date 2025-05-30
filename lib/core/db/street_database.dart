import 'package:asrdb/core/models/street/street.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StreetDatabase {
  static Database? _database;
  static const String _tableName = 'streets';
  static const String _ftsTableName = 'streets_fts';
  static String? _ftsModule; // Will be 'fts5', 'fts4', or null

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'streets_database.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        globalId TEXT NOT NULL,
        strType INTEGER NOT NULL,
        strNameCore TEXT NOT NULL,
        searchTerms TEXT NOT NULL
      )
    ''');

    _ftsModule = await _detectFtsModule(db);

    if (_ftsModule != null) {
      // Create virtual FTS table (either fts5 or fts4)
      await db.execute('''
        CREATE VIRTUAL TABLE $_ftsTableName USING $_ftsModule(
          globalId,
          strNameCore,
          searchTerms,
          content='$_tableName',
          content_rowid='id'
        )
      ''');

      // Triggers to keep FTS table in sync
      await db.execute('''
        CREATE TRIGGER streets_ai AFTER INSERT ON $_tableName BEGIN
          INSERT INTO $_ftsTableName(rowid, globalId, strNameCore, searchTerms)
          VALUES (new.id, new.globalId, new.strNameCore, new.searchTerms);
        END
      ''');

      await db.execute('''
        CREATE TRIGGER streets_ad AFTER DELETE ON $_tableName BEGIN
          INSERT INTO $_ftsTableName($_ftsTableName, rowid, globalId, strNameCore, searchTerms)
          VALUES('delete', old.id, old.globalId, old.strNameCore, old.searchTerms);
        END
      ''');

      await db.execute('''
        CREATE TRIGGER streets_au AFTER UPDATE ON $_tableName BEGIN
          INSERT INTO $_ftsTableName($_ftsTableName, rowid, globalId, strNameCore, searchTerms)
          VALUES('delete', old.id, old.globalId, old.strNameCore, old.searchTerms);
          INSERT INTO $_ftsTableName(rowid, globalId, strNameCore, searchTerms)
          VALUES (new.id, new.globalId, new.strNameCore, new.searchTerms);
        END
      ''');
    }

    await db.execute('CREATE INDEX idx_street_name ON $_tableName(strNameCore)');
  }

  static Future<String?> _detectFtsModule(Database db) async {
    final result = await db.rawQuery('PRAGMA compile_options;');
    final options = result.map((e) => e.values.first.toString()).toList();

    if (options.any((e) => e.contains('ENABLE_FTS5'))) return 'fts5';
    if (options.any((e) => e.contains('ENABLE_FTS4'))) return 'fts4';
    return null;
  }

  static Future<int> insertStreet(Street street) async {
    final db = await database;
    final searchTerms = _generateSearchTerms(street.strNameCore);
    return await db.insert(_tableName, {
      'globalId': street.globalId,
      'strType': street.strType,
      'strNameCore': street.strNameCore,
      'searchTerms': searchTerms,
    });
  }

  static Future<void> insertStreetsBatch(List<Street> streets) async {
    final db = await database;
    final batch = db.batch();
    for (final street in streets) {
      final searchTerms = _generateSearchTerms(street.strNameCore);
      batch.insert(_tableName, {
        'globalId': street.globalId,
        'strType': street.strType,
        'strNameCore': street.strNameCore,
        'searchTerms': searchTerms,
      });
    }
    await batch.commit(noResult: true);
  }

  static Future<Street?> getStreetByGlobalId(String globalId) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'globalId = ?',
      whereArgs: [globalId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Street.create(
        globalId: maps.first['globalId'] as String,
        strType: maps.first['strType'] as int,
        strNameCore: maps.first['strNameCore'] as String,
      );
    }
    return null;
  }

  static String _generateSearchTerms(String streetName) {
    final terms = <String>[];
    final words = streetName.toLowerCase().split(' ');

    terms.addAll(words);

    if (words.length > 1) {
      terms.add(words.join(' '));
      for (int i = 0; i < words.length - 1; i++) {
        terms.add(words.sublist(i, i + 2).join(' '));
      }
    }

    return terms.join(' ');
  }

  static Future<List<Street>> searchStreetsFTS(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];

    if (_ftsModule == null) {
      // fallback to LIKE if FTS is unavailable
      return searchStreetsLike(query, limit: limit);
    }

    final db = await database;

    final ftsQuery = query
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) => '$word*')
        .join(' AND ');

    final maps = await db.rawQuery('''
      SELECT s.globalId, s.strType, s.strNameCore
      FROM $_ftsTableName fts
      JOIN $_tableName s ON fts.rowid = s.id
      WHERE fts.searchTerms MATCH ?
      LIMIT ?
    ''', [ftsQuery, limit]);

    return maps
        .map((map) => Street.create(
              globalId: map['globalId'] as String,
              strType: map['strType'] as int,
              strNameCore: map['strNameCore'] as String,
            ))
        .toList();
  }

  static Future<List<Street>> searchStreetsLike(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];

    final db = await database;
    final searchPattern = '%${query.toLowerCase()}%';

    final maps = await db.query(
      _tableName,
      where: 'LOWER(strNameCore) LIKE ? OR LOWER(searchTerms) LIKE ?',
      whereArgs: [searchPattern, searchPattern],
      orderBy: '''
        CASE 
          WHEN LOWER(strNameCore) LIKE ? THEN 1
          WHEN LOWER(strNameCore) LIKE ? THEN 2
          ELSE 3
        END, strNameCore
      ''',
      limit: limit,
    );

    return maps
        .map((map) => Street.create(
              globalId: map['globalId'] as String,
              strType: map['strType'] as int,
              strNameCore: map['strNameCore'] as String,
            ))
        .toList();
  }

  static Future<List<Street>> searchStreetsStartsWith(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];

    final db = await database;
    final searchPattern = '${query.toLowerCase()}%';

    final maps = await db.query(
      _tableName,
      where: 'LOWER(strNameCore) LIKE ?',
      whereArgs: [searchPattern],
      orderBy: 'strNameCore',
      limit: limit,
    );

    return maps
        .map((map) => Street.create(
              globalId: map['globalId'].toString(),
              strType: map['strType'] as int,
              strNameCore: map['strNameCore'] as String,
            ))
        .toList();
  }

  static Future<void> clearAllStreets() async {
    final db = await database;
    await db.delete(_tableName);
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
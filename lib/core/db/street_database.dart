import 'package:asrdb/core/models/street/street.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StreetDatabase {
  static Database? _database;
  static const String _tableName = 'streets';
  static const String _ftsTableName = 'streets_fts';

  // Singleton pattern
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'streets_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create main table
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        globalId TEXT NOT NULL,
        strType INTEGER NOT NULL,
        strNameCore TEXT NOT NULL,
        searchTerms TEXT NOT NULL
      )
    ''');

    // Create FTS5 virtual table for fast searching
    await db.execute('''
      CREATE VIRTUAL TABLE $_ftsTableName USING fts5(
        globalId,
        strNameCore,
        searchTerms,
        content='$_tableName',
        content_rowid='id'
      )
    ''');

    // Create triggers to keep FTS table in sync
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

    // Create index for traditional queries
    await db.execute('CREATE INDEX idx_street_name ON $_tableName(strNameCore)');
  }

  // Insert single street
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

  // Batch insert for better performance with thousands of records
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

  // Generate search terms for better matching
  static String _generateSearchTerms(String streetName) {
    final terms = <String>[];
    final words = streetName.toLowerCase().split(' ');
    
    // Add original words
    terms.addAll(words);
    
    // Add combinations for multi-word streets
    if (words.length > 1) {
      terms.add(words.join(' '));
      // Add partial combinations
      for (int i = 0; i < words.length - 1; i++) {
        terms.add(words.sublist(i, i + 2).join(' '));
      }
    }
    
    return terms.join(' ');
  }

  // Fast FTS search - best for instant search
  static Future<List<Street>> searchStreetsFTS(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];
    
    final db = await database;
    
    // Prepare query for FTS5
    final ftsQuery = query.trim().split(' ')
        .map((word) => '"$word"*')  // Use prefix matching
        .join(' AND ');
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.globalId, s.strType, s.strNameCore
      FROM $_ftsTableName fts
      JOIN $_tableName s ON fts.rowid = s.id
      WHERE $_ftsTableName MATCH ?
      ORDER BY rank
      LIMIT ?
    ''', [ftsQuery, limit]);

    return maps.map((map) => Street.create(
      globalId: map['globalId'],
      strType: map['strType'],
      strNameCore: map['strNameCore'],
    )).toList();
  }

  // Traditional LIKE search as fallback
  static Future<List<Street>> searchStreetsLike(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];
    
    final db = await database;
    final searchPattern = '%${query.toLowerCase()}%';
    
    final List<Map<String, dynamic>> maps = await db.query(
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

    return maps.map((map) => Street.create(
      globalId: map['globalId'],
      strType: map['strType'],
      strNameCore: map['strNameCore'],
    )).toList();
  }

  // Starts-with search
  static Future<List<Street>> searchStreetsStartsWith(String query, {int limit = 50}) async {
    if (query.trim().isEmpty) return [];
    
    final db = await database;
    final searchPattern = '${query.toLowerCase()}%';
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'LOWER(strNameCore) LIKE ?',
      whereArgs: [searchPattern],
      orderBy: 'strNameCore',
      limit: limit,
    );

    return maps.map((map) => Street.create(
      globalId: map['globalId'],
      strType: map['strType'],
      strNameCore: map['strNameCore'],
    )).toList();
  }

  // Get all streets with pagination
  static Future<List<Street>> getAllStreets({int offset = 0, int limit = 100}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'strNameCore',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Street.create(
      globalId: map['globalId'],
      strType: map['strType'],
      strNameCore: map['strNameCore'],
    )).toList();
  }

  // Count total streets
  static Future<int> getStreetsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return result.first['count'] as int;
  }

  // Clear all data
  static Future<void> clearAllStreets() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // Close database
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
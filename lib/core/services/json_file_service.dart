import 'dart:io';
import 'dart:convert';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:path_provider/path_provider.dart';
import 'package:asrdb/core/api/building_api.dart';
import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/api/schema_api.dart';
import 'package:asrdb/core/services/json_fetch_service.dart';

class JsonFileService {
  late final JsonFetchService _jsonFetchService;

  JsonFileService() {
    _jsonFetchService = JsonFetchService(
      BuildingApi(),
      EntranceApi(),
      DwellingApi(),
      SchemaApi(),
    );
  }


  Future<Directory> _getJsonDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final jsonDir = Directory('${appDir.path}/json_schemas');

    if (!await jsonDir.exists()) {
      await jsonDir.create(recursive: true);
    }
    return jsonDir;
  }

  Future<bool> areJsonFilesExist() async {
    try {
      final jsonDir = await _getJsonDirectory();

      final buildingFile = File('${jsonDir.path}/building.json');
      final entranceFile = File('${jsonDir.path}/entrance.json');
      final dwellingFile = File('${jsonDir.path}/dwelling.json');

      return await buildingFile.exists() &&
          await entranceFile.exists() &&
          await dwellingFile.exists();
    } catch (e) {
      return false;
    }
  }

  Future<bool> areSchemaFilesExist() async {
    try {
      final jsonDir = await _getJsonDirectory();

      final entranceSchemaFile = File('${jsonDir.path}/entrance_schema.json');
      final buildingSchemaFile = File('${jsonDir.path}/building_schema.json');
      final dwellingSchemaFile = File('${jsonDir.path}/dwelling_schema.json');

      return await entranceSchemaFile.exists() &&
          await buildingSchemaFile.exists() &&
          await dwellingSchemaFile.exists();
    } catch (e) {
      return false;
    }
  }

  Future<void> saveJsonFiles() async {
    try {
      final jsonDir = await _getJsonDirectory();
      final buildingJson = await _jsonFetchService.getBuildingJson();
      final entranceJson = await _jsonFetchService.getEntranceJson();
      final dwellingJson = await _jsonFetchService.getDwellingJson();
      await _saveJsonToFile('${jsonDir.path}/building.json', buildingJson);
      await _saveJsonToFile('${jsonDir.path}/entrance.json', entranceJson);
      await _saveJsonToFile('${jsonDir.path}/dwelling.json', dwellingJson);
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<void> saveSchemaFiles() async {
    try {
      final jsonDir = await _getJsonDirectory();
      final entranceSchemaJson = await _jsonFetchService.getEntranceSchemaJson();
      final buildingSchemaJson = await _jsonFetchService.getBuildingSchemaJson();
      final dwellingSchemaJson = await _jsonFetchService.getDwellingSchemaJson();
      await _saveJsonToFile('${jsonDir.path}/entrance_schema.json', entranceSchemaJson);
      await _saveJsonToFile('${jsonDir.path}/building_schema.json', buildingSchemaJson);
      await _saveJsonToFile('${jsonDir.path}/dwelling_schema.json', dwellingSchemaJson);
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<void> saveAllFiles() async {
    await saveJsonFiles();
    await saveSchemaFiles();
  }

  Future<void> _saveJsonToFile(String filePath, String jsonString) async {
    try {
      final file = File(filePath);
      final jsonData = jsonDecode(jsonString);
      const encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(jsonData);

      await file.writeAsString(prettyJson);    
      // ignore: empty_catches
    } catch (e) {
     
    }
  }

  Future<String?> readJsonFile(String fileName) async {
    try {
      final jsonDir = await _getJsonDirectory();
      final file = File('${jsonDir.path}/$fileName');

      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getBuildingJsonFromFile() async {
    return await readJsonFile('building.json');
  }

  Future<String?> getEntranceJsonFromFile() async {
    return await readJsonFile('entrance.json');
  }

  Future<String?> getDwellingJsonFromFile() async {
    return await readJsonFile('dwelling.json');
  }

  Future<String?> getEntranceSchemaJsonFromFile() async {
    return await readJsonFile('entrance_schema.json');
  }

  Future<String?> getBuildingSchemaJsonFromFile() async {
    return await readJsonFile('building_schema.json');
  }

  Future<String?> getDwellingSchemaJsonFromFile() async {
    return await readJsonFile('dwelling_schema.json');
  }

Future<List<FieldSchema>> getAttributes(String fileName) async {
  try {
    final raw = await readJsonFile(fileName);
    if (raw == null) {
      throw Exception('$fileName not found or unreadable');
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid JSON structure in $fileName');
    }

    final fields = decoded['fields'];
    if (fields is! List) {
      throw Exception('"fields" key is missing or not a list in $fileName');
    }

    return fields
        .map<FieldSchema>((e) => FieldSchema.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    throw Exception('Get attributes from $fileName failed: $e');
  }
}

  Future<void> deleteJsonFiles() async {
    try {
      final jsonDir = await _getJsonDirectory();

      final buildingFile = File('${jsonDir.path}/building.json');
      final entranceFile = File('${jsonDir.path}/entrance.json');
      final dwellingFile = File('${jsonDir.path}/dwelling.json');

      if (await buildingFile.exists()) await buildingFile.delete();
      if (await entranceFile.exists()) await entranceFile.delete();
      if (await dwellingFile.exists()) await dwellingFile.delete();
       // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<void> deleteSchemaFiles() async {
    try {
      final jsonDir = await _getJsonDirectory();

      final entranceSchemaFile = File('${jsonDir.path}/entrance_schema.json');
      final buildingSchemaFile = File('${jsonDir.path}/building_schema.json');
      final dwellingSchemaFile = File('${jsonDir.path}/dwelling_schema.json');

      if (await entranceSchemaFile.exists()) await entranceSchemaFile.delete();
      if (await buildingSchemaFile.exists()) await buildingSchemaFile.delete();
      if (await dwellingSchemaFile.exists()) await dwellingSchemaFile.delete();
       // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<Map<String, String>> getJsonFilePaths() async {
    final jsonDir = await _getJsonDirectory();

    return {
      'building': '${jsonDir.path}/building.json',
      'entrance': '${jsonDir.path}/entrance.json',
      'dwelling': '${jsonDir.path}/dwelling.json',
    };
  }

  Future<Map<String, String>> getSchemaFilePaths() async {
    final jsonDir = await _getJsonDirectory();

    return {
      'entrance_schema': '${jsonDir.path}/entrance_schema.json',
      'building_schema': '${jsonDir.path}/building_schema.json',
      'dwelling_schema': '${jsonDir.path}/dwelling_schema.json',
    };
  }
}

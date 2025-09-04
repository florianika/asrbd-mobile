import 'dart:convert';
import 'package:asrdb/core/services/json_file_service.dart';
import 'package:asrdb/core/models/attributes/attribute_schema.dart';

class SchemaService {
  final JsonFileService jsonFileService;
  AttributeSchema? _buildingSchema;
  AttributeSchema? _entranceSchema;
  AttributeSchema? _dwellingSchema;

  bool _isInitialized = false;

  SchemaService(this.jsonFileService);

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final futures = await Future.wait([
        _fetchBuildingSchema(),
        _fetchEntranceSchema(),
        _fetchDwellingSchema(),
      ]);

      _buildingSchema = futures[0];
      _entranceSchema = futures[1];
      _dwellingSchema = futures[2];

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize schemas: $e');
    }
  }

  Future<AttributeSchema> _fetchBuildingSchema() async {
    try {
      
      final jsonString = await jsonFileService.getBuildingSchemaJsonFromFile();
      if (jsonString == null) {
        throw Exception('Building schema file not found');
      }
      
      final jsonData = jsonDecode(jsonString);
      return AttributeSchema.fromJson(jsonData);
    } catch (e) {
      throw Exception('Building schema load failed: $e');
    }
  }

  Future<AttributeSchema> _fetchEntranceSchema() async {
    try {
      final jsonString = await jsonFileService.getEntranceSchemaJsonFromFile();
      if (jsonString == null) {
        throw Exception('Entrance schema file not found');
      }
      
      final jsonData = jsonDecode(jsonString);
      return AttributeSchema.fromJson(jsonData);
    } catch (e) {
      throw Exception('Entrance schema load failed: $e');
    }
  }

  Future<AttributeSchema> _fetchDwellingSchema() async {
    try {
      final jsonString = await jsonFileService.getDwellingSchemaJsonFromFile();
      if (jsonString == null) {
        throw Exception('Dwelling schema file not found');
      }
      
      final jsonData = jsonDecode(jsonString);
      return AttributeSchema.fromJson(jsonData);
    } catch (e) {
      throw Exception('Dwelling schema load failed: $e');
    }
  }


  AttributeSchema get buildingSchema {
    if (!_isInitialized || _buildingSchema == null) {
      throw Exception('Schemas not initialized. Call initialize() first.');
    }
    return _buildingSchema!;
  }

  AttributeSchema get entranceSchema {
    if (!_isInitialized || _entranceSchema == null) {
      throw Exception('Schemas not initialized. Call initialize() first.');
    }
    return _entranceSchema!;
  }

  AttributeSchema get dwellingSchema {
    if (!_isInitialized || _dwellingSchema == null) {
      throw Exception('Schemas not initialized. Call initialize() first.');
    }
    return _dwellingSchema!;
  }

  SchemaAttribute? getBuildingAttribute(String name) {
    return buildingSchema.getByName(name);
  }

  SchemaAttribute? getEntranceAttribute(String name) {
    return entranceSchema.getByName(name);
  }

  SchemaAttribute? getDwellingAttribute(String name) {
    return dwellingSchema.getByName(name);
  }

  bool get isInitialized => _isInitialized;

  Future<bool> areSchemaFilesAvailable() async {
    return await jsonFileService.areJsonFilesExist();
  }

  Future<void> saveSchemaFiles() async {
    await jsonFileService.saveSchemaFiles();
  }

  Future<void> initializeWithFallback() async {
    if (_isInitialized) return;

    try {
      final filesExist = await jsonFileService.areSchemaFilesExist();
      
      if (!filesExist) {
        await jsonFileService.saveSchemaFiles();
      }

   
      await initialize();
    } catch (e) {
      throw Exception('Failed to initialize schemas with fallback: $e');
    }
  }

  Future<void> refresh() async {
    _isInitialized = false;
    _buildingSchema = null;
    _entranceSchema = null;
    _dwellingSchema = null;
    await initialize();
  }

  Future<void> refreshAndSave() async {
    _isInitialized = false;
    _buildingSchema = null;
    _entranceSchema = null;
    _dwellingSchema = null;
    await jsonFileService.saveSchemaFiles();
    await initialize();
  }
}

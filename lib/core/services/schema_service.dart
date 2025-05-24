import 'package:asrdb/core/api/schema_api.dart';
import 'package:asrdb/core/models/attributes/attribute_schema.dart';

class SchemaService {
  final SchemaApi schemaApi;

  // Cache for schemas
  AttributeSchema? _buildingSchema;
  AttributeSchema? _entranceSchema;
  AttributeSchema? _dwellingSchema;

  bool _isInitialized = false;

  SchemaService(this.schemaApi);

  // Initialize all schemas at app startup
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Fetch all schemas concurrently
      final futures = await Future.wait([
        _fetchBuildingSchema(),
        _fetchEntranceSchema(),
        _fetchDwellingSchema(),
      ]);

      _buildingSchema = futures[0];
      _entranceSchema = futures[1];
      _dwellingSchema = futures[2];

      _isInitialized = true;
      // print('All schemas loaded successfully');
    } catch (e) {
      // print('Error initializing schemas: $e');
      throw Exception('Failed to initialize schemas: $e');
    }
  }

  // Private methods to fetch schemas
  Future<AttributeSchema> _fetchBuildingSchema() async {
    try {
      final response = await schemaApi.getBuildingSchema();
      if (response.statusCode == 200) {
        return AttributeSchema.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch building schema');
      }
    } catch (e) {
      throw Exception('Building schema fetch failed: $e');
    }
  }

  Future<AttributeSchema> _fetchEntranceSchema() async {
    try {
      final response = await schemaApi.getEntranceSchema();
      if (response.statusCode == 200) {
        return AttributeSchema.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch entrance schema');
      }
    } catch (e) {
      throw Exception('Entrance schema fetch failed: $e');
    }
  }

  Future<AttributeSchema> _fetchDwellingSchema() async {
    try {
      final response = await schemaApi.getDwellingSchema();
      if (response.statusCode == 200) {
        return AttributeSchema.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch dwelling schema');
      }
    } catch (e) {
      throw Exception('Dwelling schema fetch failed: $e');
    }
  }

  // Getters for cached schemas
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

  // Helper methods to get specific attributes
  SchemaAttribute? getBuildingAttribute(String name) {
    return buildingSchema.getByName(name);
  }

  SchemaAttribute? getEntranceAttribute(String name) {
    return entranceSchema.getByName(name);
  }

  SchemaAttribute? getDwellingAttribute(String name) {
    return dwellingSchema.getByName(name);
  }

  // Check if schemas are loaded
  bool get isInitialized => _isInitialized;

  // Refresh schemas (if needed)
  Future<void> refresh() async {
    _isInitialized = false;
    _buildingSchema = null;
    _entranceSchema = null;
    _dwellingSchema = null;
    await initialize();
  }
}

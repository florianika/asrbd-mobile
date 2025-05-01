import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/building/building_fields.dart';
import 'package:asrdb/core/models/dwelling/dwelling_fields.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:dio/dio.dart'; 
import 'package:flutter/material.dart';

const entranceUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/0';
const buildingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1';
const dwellingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/2';

const entityFieldWhitelist = {
   'entrance': EntranceFields.all,
   'building': BuildingFields.all,
   'dwelling': DwellingFields.all,
};

String getEntityFromUrl(String url) {
  if (url.contains('/0')) return 'entrance';
  if (url.contains('/1')) return 'building';
  if (url.contains('/2')) return 'dwelling';
  return 'unknown';
}

String getUrlFromEntity(String entity) {
  switch (entity) {
    case 'entrance':
      return entranceUrl;
    case 'building':
      return buildingUrl;
    case 'dwelling':
      return dwellingUrl;
    default:
      throw Exception('Unknown entity: $entity');
  }
}

  final StorageService _storage = StorageService();
  Future<List<FieldSchema>> fetchFields(String layerUrl) async {
  String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);


  final Dio dio = Dio();

  try {
    final response = await dio.get(
      '$layerUrl?f=json&token=$esriToken',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['fields'] == null) {
        throw Exception('Missing "fields" key in response: $data');
      }

      return (data['fields'] as List)
          .map((e) => FieldSchema.fromJson(e))
          .toList();
    } else {
      throw Exception('Schema fetch failed: ${response.statusCode} - ${response.data}');
    }
  } catch (e) {
    throw Exception('Failed to fetch fields: $e');
  }
}

class FieldSchema {
  final String name;
  final String alias;
  final String type;
  final bool editable;
  final bool nullable;
  final dynamic defaultValue;
  final List<Map<String, dynamic>>? codedValues;

  FieldSchema({
    required this.name,
    required this.alias,
    required this.type,
    required this.editable,
    required this.nullable,
    this.defaultValue,
    this.codedValues,
  });

  factory FieldSchema.fromJson(Map<String, dynamic> json) {
    return FieldSchema(
      name: json['name'],
      alias: json['alias'] ?? json['name'],
      type: json['type'],
      editable: json['editable'] ?? false,
      nullable: json['nullable'] ?? true,
      defaultValue: json['defaultValue'],
      codedValues: (json['domain']?['codedValues'] as List?)?.map((e) => {
        'code': e['code'],
        'name': e['name'],
      }).toList(),
    );
  }
}

class DynamicForm extends StatefulWidget {
  final List<FieldSchema> schema;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>)? onSave;

  const DynamicForm({
    required this.schema,
    this.initialData,
    this.onSave,
    super.key,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final Map<String, dynamic> formValues = {};

  @override
  void initState() {
    super.initState();
    formValues.addAll(widget.initialData ?? {});
  }

  void _handleSave() {
    if (widget.onSave != null) {
      widget.onSave!(formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.schema.map((field) {
          final value = formValues[field.name] ?? field.defaultValue;
          if (field.codedValues != null) {
            return DropdownButtonFormField(
              decoration: InputDecoration(labelText: field.alias),
              value: value,
              items: field.codedValues!
                  .map((code) => DropdownMenuItem(
                        value: code['code'],
                        child: Text(code['name'].toString()),
                      ))
                  .toList(),
              onChanged: field.editable
                  ? (val) => setState(() => formValues[field.name] = val)
                  : null,
              disabledHint: Text(
                value != null ? value.toString() : '',
                style: const TextStyle(color: Colors.black45),
              ),
            );
          }
          return TextFormField(
            decoration: InputDecoration(labelText: field.alias),
            initialValue: value?.toString() ?? '',
            onChanged: field.editable
                ? (val) => setState(() => formValues[field.name] = val)
                : null,
            enabled: field.editable,
          );
        }).toList(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

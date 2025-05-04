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
    final response = await dio.get('$layerUrl?f=json&token=$esriToken');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['fields'] == null) {
        throw Exception('Missing "fields" key in response: $data');
      }
      return (data['fields'] as List)
          .map((e) => FieldSchema.fromJson(e))
          .toList();
    } else {
      throw Exception(
          'Schema fetch failed: ${response.statusCode} - ${response.data}');
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
      codedValues: (json['domain']?['codedValues'] as List?)
          ?.map((e) => {
                'code': e['code'],
                'name': e['name'],
              })
          .toList(),
    );
  }
}

class DynamicForm extends StatefulWidget {
  final List<FieldSchema> schema;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>)? onSave;
  final void Function()? onClose;

  const DynamicForm({
    required this.schema,
    this.initialData,
    this.onSave,
    this.onClose,
    super.key,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final Map<String, dynamic> formValues = {};
  final Map<String, String> _validationStatus = {};

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

  void _handleValidate() {
    setState(() {
      _validationStatus.clear();
      _validationStatus.addAll({
        'BldLatitude': 'valid',
        'BldLongitude': 'error',
        'BldHeight': 'valid',
        'BldFloorsAbove': 'error',
        'BldCensus2023': 'valid',
        'BldPermitDate': 'error',
      });
    });
  }

  Widget _buildValidationIcon(String fieldName) {
    if (!_validationStatus.containsKey(fieldName)) {
      return const SizedBox.shrink();
    }

    final status = _validationStatus[fieldName];
    final isError = status == 'error';

    return Tooltip(
      message: isError ? 'Error found' : 'No error found',
      triggerMode: TooltipTriggerMode.tap,
      preferBelow: false,
      verticalOffset: 20,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.white),
      child: Icon(
        isError ? Icons.error : Icons.info,
        color: isError ? Colors.red : Colors.green,
        size: 20,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.schema.map((field) {
          final value = formValues[field.name] ?? field.defaultValue;

          final inputWidget = field.codedValues != null
              ? DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: field.alias,
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  value: value,
                  items: field.codedValues!
                      .map((code) => DropdownMenuItem(
                            value: code['code'],
                            child: Text(
                              code['name'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: field.editable
                      ? (val) => setState(() => formValues[field.name] = val)
                      : null,
                  disabledHint: Text(
                    value != null ? value.toString() : '',
                    style: const TextStyle(color: Colors.black45),
                  ),
                )
              : TextFormField(
                  decoration: InputDecoration(
                    labelText: field.alias,
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  initialValue: value?.toString() ?? '',
                  onChanged: field.editable
                      ? (val) => setState(() => formValues[field.name] = val)
                      : null,
                  enabled: field.editable,
                );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: inputWidget),
                const SizedBox(width: 4),
                _buildValidationIcon(field.name),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                if (widget.onClose != null) {
                  widget.onClose!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.close, color: Colors.black),
              label: const Text('Close', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _handleValidate,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Validate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

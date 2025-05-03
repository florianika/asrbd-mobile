import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
// import 'package:asrdb/core/models/building/building_fields.dart';
// import 'package:asrdb/core/models/dwelling/dwelling_fields.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const entranceUrl =
    'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/0';
const buildingUrl =
    'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1';
const dwellingUrl =
    'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/2';

const entityFieldWhitelist = {
  'entrance': EntranceFields.all,
  'buildings': EntranceFields.all,
  // 'dwelling': DwellingFields.all,
};

String getEntityFromUrl(String url) {
  if (url.contains('/0')) return 'entrance';
  if (url.contains('/1')) return 'buildings';
  if (url.contains('/2')) return 'dwelling';
  return 'unknown';
}

String getUrlFromEntity(EntityType entity) {
  switch (entity) {
    case EntityType.entrance:
      return entranceUrl;
    case EntityType.building:
      return buildingUrl;
    case EntityType.dwelling:
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

  @override
  void initState() {
    super.initState();
    formValues.addAll(widget.initialData ?? {});
  }

  @override
  void didUpdateWidget(covariant DynamicForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData &&
        widget.initialData != null) {
      setState(() {
        formValues.clear();
        formValues.addAll(widget.initialData!);
      });
    }
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
            // Deduplicate by 'code' and ensure all 'code' values are not null
            final seenCodes = <dynamic>{};
            final uniqueCodedValues = field.codedValues!
                .where((item) =>
                    item['code'] != null && seenCodes.add(item['code']))
                .toList();

            // Get current value
            final selectedValue = formValues[field.name];

            // Ensure the selected value is in the unique list
            final valueExists =
                uniqueCodedValues.any((item) => item['code'] == selectedValue);
            final effectiveValue = valueExists ? selectedValue : null;

            return DropdownButtonFormField(
              key: ValueKey('${field.name}_$effectiveValue'),
              isExpanded: true,
              decoration: InputDecoration(
                labelText: field.alias,
                labelStyle: const TextStyle(color: Colors.black),
              ),
              value: effectiveValue,
              items: uniqueCodedValues
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
                effectiveValue != null ? effectiveValue.toString() : '',
                style: const TextStyle(color: Colors.black45),
              ),
            );
          }
          return TextFormField(
            key: ValueKey('${field.name}_${formValues[field.name]}'),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _handleSave,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

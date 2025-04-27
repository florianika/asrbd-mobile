import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:dio/dio.dart'; // <-- using Dio now
import 'package:flutter/material.dart';

// ---- URLs for each entity ----
const entranceUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/0';
const buildingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1';
const dwellingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/2';

// ---- Whitelisted fields per entity ----
const entityFieldWhitelist = {
  'entrance': [
    'EntStreet', 'EntCensus2023', 'external_creator_date', 'external_editor_date',
    'EntBuildingID', 'EntAddressID', 'EntQuality', 'EntLatitude', 'EntLongitude',
    'EntPointStatus', 'EntBuildingNumber', 'EntEntranceNumber', 'EntTown',
    'EntZipCode', 'EntDwellingRecs', 'EntDwellingExpec', 'external_creator',
    'external_editor'
  ],
  'building': [
    'BldCensus2023', 'BldQuality', 'BldMunicipality', 'BldEnumArea', 'BldLatitude',
    'BldLongitude', 'BldCadastralZone', 'BldProperty', 'BldPermitNumber',
    'BldPermitDate', 'BldStatus', 'BldYearConstruction', 'BldYearDemolition',
    'BldType', 'BldClass', 'BldArea', 'BldFloorsAbove', 'BldFloorsUnder', 'BldHeight',
    'BldVolume', 'BldPipedWater', 'BldRainWater', 'BldWasteWater', 'BldElectricity',
    'BldPipedGas', 'BldElevator', 'BldCentroidStatus', 'BldDwellingRecs',
    'BldEntranceRecs', 'BldAddressID', 'external_creator', 'external_editor',
    'external_creator_date', 'external_editor_date'
  ],
  'dwelling': [
    'external_creator_date', 'external_editor_date', 'DwlEntranceID', 'DwlCensus2023',
    'DwlAddressID', 'DwlQuality', 'DwlFloor', 'DwlApartNumber', 'DwlStatus',
    'DwlYearConstruction', 'DwlYearElimination', 'DwlType', 'DwlOwnership',
    'DwlOccupancy', 'DwlSurface', 'DwlWaterSupply', 'DwlToilet', 'DwlBath',
    'DwlHeatingFacility', 'DwlHeatingEnergy', 'DwlAirConditioner', 'DwlSolarPanel',
    'external_creator', 'external_editor'
  ]
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
  //const token = esriToken;//We should add token here

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

  const DynamicForm({required this.schema, this.initialData, super.key});

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
  Widget build(BuildContext context) {
    return Column(
      children: widget.schema.map((field) {
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
    );
  }
}

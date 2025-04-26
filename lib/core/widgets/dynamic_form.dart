import 'package:asrdb/core/widgets/phone_form_view.dart';
import 'package:asrdb/core/widgets/tablet_form_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


const entranceUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/0';
const buildingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1';
const dwellingUrl = 'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/2';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form',
      home: const HomeScreen(),
      routes: {
        '/entrance': (_) => const FormScreen(layerUrl: entranceUrl),
        '/building': (_) => const FormScreen(layerUrl: buildingUrl),
        '/dwelling': (_) => const FormScreen(layerUrl: dwellingUrl),
      },
    );
  }
}


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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _btn(BuildContext context, String label, String url) {
    final isTablet = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          if (isTablet) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TabletFormView(url: url),
              ),
            );
          } else {
            phoneFormView(context, url);
          }
        },
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose API Entity")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _btn(context, "Entrance", entranceUrl),
            _btn(context, "Building", buildingUrl),
            _btn(context, "Dwelling", dwellingUrl),
          ],
        ),
      ),
    );
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


final Dio _dio = Dio();

Future<List<FieldSchema>> fetchFields(String layerUrl) async {
  const token = '';//We should take the token and put it here.

  try {
    final response = await _dio.get(
      layerUrl,
      queryParameters: {
        'f': 'json',
        'token': token,
      },
    );

    final data = response.data;

    if (data['fields'] == null) {
      throw Exception('Missing "fields" key in response: ${response.data}');
    }

    return (data['fields'] as List)
        .map((e) => FieldSchema.fromJson(e))
        .toList();
  } on DioException catch (e) {
    throw Exception('Schema fetch failed: ${e.response?.statusCode} - ${e.response?.data}');
  }
}

class FormScreen extends StatefulWidget {
  final String layerUrl;
  final Map<String, dynamic>? initialData;

  const FormScreen({required this.layerUrl, this.initialData, super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<FieldSchema> _schema = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchFields(widget.layerUrl).then((fields) {
      final entity = getEntityFromUrl(widget.layerUrl);
      final filtered = fields.where((f) => entityFieldWhitelist[entity]?.contains(f.name) ?? false).toList();
      setState(() {
        _schema = filtered;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form for ${getEntityFromUrl(widget.layerUrl).toUpperCase()}"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DynamicForm(schema: _schema, initialData: widget.initialData),
      ),
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
        if (!field.editable) return const SizedBox.shrink();

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
            onChanged: (val) => setState(() => formValues[field.name] = val),
          );
        }

        return TextFormField(
          decoration: InputDecoration(labelText: field.alias),
          initialValue: value?.toString() ?? '',
          onChanged: (val) => formValues[field.name] = val,
        );
      }).toList(),
    );
  }
}

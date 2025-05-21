import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/shape_type.dart';
import '../../../features/home/presentation/dwelling_cubit.dart';

class DwellingForm extends StatefulWidget {
  final ShapeType selectedShapeType;
  final String? entranceGlobalId;
  final VoidCallback onBack;

  const DwellingForm(
    {super.key, 
    required this.selectedShapeType,
     this.entranceGlobalId,
     required this.onBack,
    });

  @override
  State<DwellingForm> createState() => _DwellingFormState();
}

class _DwellingFormState extends State<DwellingForm> {
  final List<Map<String, dynamic>> _dwellingRows = [];
  List<FieldSchema> _dwellingSchema = [];
  bool _showDwellingForm = false;
  

  void _onSaveDwelling(Map<String, dynamic> attributes) {
    context.read<DwellingCubit>().addDwellingFeature(attributes);
    setState(() {
      _showDwellingForm = false;
    });
  }

  final Map<String, String> _columnLabels = {
    'DwlCensus2023': 'Census Code',
    'DwlType': 'Type',
    'DwlStatus': 'Status',
    'DwlOwnership': 'Ownership',
    'DwlOccupancy': 'Occupancy',
    'DwlToilet': 'Toilet',
    'DwlBath': 'Bath',
    'DwlAirConditioner': 'AC',
    'DwlHeatingFacility': 'Heating',
    'DwlSolarPanel': 'Solar Panel',
    'created_user': 'Created By',
    'created_date': 'Created Date',
    'last_edited_user': 'Edited By',
    'last_edited_date': 'Edited Date',
  };

  final List<String> _columnOrder = [
    'DwlCensus2023',
    'DwlType',
    'DwlStatus',
    'DwlOwnership',
    'DwlOccupancy',
    'DwlToilet',
    'DwlBath',
    'DwlAirConditioner',
  ];

  @override
  void initState() {
    super.initState();
     final id=widget.entranceGlobalId;
    //context.read<DwellingCubit>().getDwellings('{6C76FE17-C925-4355-B917-446C39FA0E48}');
    context.read<DwellingCubit>().getDwellings(id);
  }
   
   
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DwellingCubit, DwellingState>(
      listener: (context, state) {
        if (state is Dwellings) {
          final features = state.dwellings['features'] as List<dynamic>;
          setState(() {
            _dwellingRows.clear();
            _dwellingRows.addAll(
              features.map((f) => Map<String, dynamic>.from(f['properties'])),
            );
          });
        } else if (state is DwellingAttributes) {
          setState(() {
            _dwellingSchema = state.attributes;
            _showDwellingForm = true;
          });
        } else if (state is DwellingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            title: const Text("Dwellings"),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _onAddNewDwelling,
                            icon: const Icon(Icons.add),
                            label: const Text("New"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state is DwellingLoading)
                        const Center(child: CircularProgressIndicator()),
                      if (_dwellingRows.isEmpty && state is! DwellingLoading)
                        const Center(child: Text("No dwellings found.")),
                      if (_dwellingRows.isNotEmpty)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columns: _buildColumns(),
                                rows: _dwellingRows.map(_buildDataRow).toList(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_showDwellingForm)
                  Expanded(
                    flex: 1,
                    child: TabletElementAttribute(
                      schema: _dwellingSchema,
                      selectedShapeType: ShapeType.noShape,
                      initialData: const {},
                      onClose: () {
                        setState(() {
                          _showDwellingForm = false;
                        });
                      },
                      save: (formValues) {
                        _onSaveDwelling(formValues);
                        setState(() {
                          _showDwellingForm = false;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text("Actions")),
      ..._columnOrder.map((key) {
        final label = _columnLabels[key] ?? key;
        return DataColumn(
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      }),
    ];
  }

  DataRow _buildDataRow(Map<String, dynamic> row) {
    return DataRow(
      cells: [
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'view') {
                _onViewDwelling(row);
              } else if (value == 'edit') {
                _onEditDwelling(row);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View Dwelling')),
              const PopupMenuItem(value: 'edit', child: Text('Edit Dwelling')),
            ],
          ),
        ),
        ..._columnOrder.map((key) {
          final value = row[key];
          return DataCell(Text(value?.toString() ?? ''));
        }),
      ],
    );
  }

  void _onViewDwelling(Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dwelling Details'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: row.entries
                .map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value?.toString() ?? '-'),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _onEditDwelling(Map<String, dynamic> row) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit clicked for OBJECTID: ${row['OBJECTID']}")),
    );
  }

  void _onAddNewDwelling() {
    context.read<DwellingCubit>().getDwellingAttibutes();
  }
}

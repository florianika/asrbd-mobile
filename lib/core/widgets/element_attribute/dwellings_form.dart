import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DwellingForm extends StatefulWidget {
  final ShapeType selectedShapeType;
  final String? entranceGlobalId;
  final VoidCallback onBack;

  const DwellingForm({
    super.key,
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
  Map<String, dynamic> _initialData = {};
  bool _isEditMode = false;

  Future<void> _onSaveDwelling(Map<String, dynamic> attributes) async {
  if (_isEditMode) {
    await context.read<DwellingCubit>().updateDwellingFeature(attributes);
  } else {
    await context.read<DwellingCubit>().addDwellingFeature(attributes);
  }

  // 2) Only now that the save has returned, fetch the updated list
  final id = widget.entranceGlobalId;
  if (id != null) {
    await context.read<DwellingCubit>().getDwellings(id);
  }

  // 3) Then hide the form
  setState(() {
    _showDwellingForm = false;
    _isEditMode = false;
  });
}

  late Map<String, String> _columnLabels ;


  late List<String> _columnOrder;

@override
void initState() {
  super.initState();

  final id = widget.entranceGlobalId;
  _initialData['DwlEntGlobalID'] = id;

  final schemaService = sl<SchemaService>();
  final dwellingSchema = schemaService.dwellingSchema;

  _columnLabels = {
    for (var attr in dwellingSchema.attributes)
      attr.name: attr.label.al,
  };

  _columnOrder = dwellingSchema.attributes
      .where((attr) => attr.display.enumerator != "none")
      .map((attr) => attr.name)
      .toList();

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
                      initialData: _initialData,
                      onClose: () {
                        setState(() {
                          _showDwellingForm = false;
                          _isEditMode = false;
                        });
                      },
                     save: (formValues) async {
                        await _onSaveDwelling(formValues);                       
                        setState(() {
                          _showDwellingForm = false;
                          _isEditMode = false;
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
          label:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
          children: _columnOrder
              .map((key) => ListTile(
                    title: Text(_columnLabels[key] ?? key),
                    subtitle: Text(row[key]?.toString() ?? '-'),
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
    final id = widget.entranceGlobalId;
    if (id != null) {
      row['DwlEntGlobalID'] = id;
    }

    setState(() {
      _initialData = row;
      _isEditMode = true;
    });

    context.read<DwellingCubit>().getDwellingAttibutes();
  }

  void _onAddNewDwelling() {
    final id = widget.entranceGlobalId;
    setState(() {
      _initialData = {'DwlEntGlobalID': id};
      _isEditMode = false;
    });

    context.read<DwellingCubit>().getDwellingAttibutes();
  }
}

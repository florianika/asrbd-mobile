import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart'; // Required for WidgetStateProperty

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
  Map<String, dynamic>? _viewPendingRow;

  late Map<String, String> _columnLabels;
  late List<String> _columnOrder;

  @override
  void initState() {
    super.initState();

    final id = widget.entranceGlobalId;
    _initialData['DwlEntGlobalID'] = id;

    final schemaService = sl<SchemaService>();
    final dwellingSchema = schemaService.dwellingSchema;

    _columnLabels = {
      for (var attr in dwellingSchema.attributes) attr.name: attr.label.al,
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
            _showDwellingForm = _viewPendingRow == null;
          });

          if (_viewPendingRow != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showViewDialog(_viewPendingRow!);
              _viewPendingRow = null;
            });
          }
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
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Scrollbar(
                                  radius: const Radius.circular(8),
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        columnSpacing: 24,
                                        horizontalMargin: 16,
                                        dataRowMinHeight: 42,
                                        dataRowMaxHeight: 56,
                                        showCheckboxColumn: false,
                                        columns: _buildColumns(),
                                        rows: _dwellingRows
                                            .asMap()
                                            .entries
                                            .map((entry) => _buildDataRow(
                                                entry.value, entry.key))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
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

  DataRow _buildDataRow(Map<String, dynamic> row, int index) {
    final status = (row['DwlQuality'] ?? '').toString().toLowerCase();

    Color? backgroundColor;
    switch (status) {
      case '2':
        backgroundColor = const Color.fromARGB(255, 250, 252, 251);
        break;
      case '9':
        backgroundColor =  const Color.fromARGB(255, 250, 252, 251);
        break;
      case '3':
        backgroundColor =  const Color.fromARGB(255, 250, 252, 251);
        break;
      default:
        backgroundColor = const Color.fromARGB(255, 250, 252, 251);
    }

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) return Colors.blue.shade50;
        return backgroundColor;
      }),
      cells: [
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'view') _onViewDwelling(row);
              if (value == 'edit') _onEditDwelling(row);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'view', child: Text('View Dwelling')),
              PopupMenuItem(value: 'edit', child: Text('Edit Dwelling')),
            ],
          ),
        ),
        ..._columnOrder.map((key) {
          final value = row[key];
          return DataCell(
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                value?.toString() ?? '',
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        }),
      ],
    );
  }

  void _onViewDwelling(Map<String, dynamic> row) {
    if (_dwellingSchema.isEmpty) {
      _viewPendingRow = row;
      context.read<DwellingCubit>().getDwellingAttibutes();
      return;
    }
    _showViewDialog(row);
  }

  void _showViewDialog(Map<String, dynamic> row) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 700,
          height: 750,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dwelling Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: TabletElementAttribute(
                  schema: _dwellingSchema,
                  selectedShapeType: ShapeType.noShape,
                  initialData: row,
                  onClose: () => Navigator.pop(context),
                  save: (_) {},
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
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

  Future<void> _onSaveDwelling(Map<String, dynamic> attributes) async {
    if (_isEditMode) {
      await context.read<DwellingCubit>().updateDwellingFeature(attributes);
    } else {
      await context.read<DwellingCubit>().addDwellingFeature(attributes);
    }

    final id = widget.entranceGlobalId;
    if (id != null) {
      await context.read<DwellingCubit>().getDwellings(id);
    }

    setState(() {
      _showDwellingForm = false;
      _isEditMode = false;
    });
  }
}

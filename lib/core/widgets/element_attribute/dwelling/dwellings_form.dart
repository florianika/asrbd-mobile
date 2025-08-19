import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/side_container.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DwellingForm extends StatefulWidget {
  final Function onSave;

  const DwellingForm({
    super.key,
    required this.onSave,
  });

  @override
  State<DwellingForm> createState() => _DwellingFormState();
}

class _DwellingFormState extends State<DwellingForm> {
  final List<DwellingEntity> _dwellingRows = [];
  final List<FieldSchema> _dwellingSchema = [];
  bool _showDwellingForm = false;
  final Map<String, dynamic> _initialData = {};
  bool _isEditMode = false;
  DwellingEntity? _viewPendingRow;
  final Set<int> _expandedDwellings = {}; // Track which dwellings are expanded
  final Set<String> _expandedFloors = {}; // Track which floors are expanded

  late Map<String, String> _columnLabels;
  late List<String> _columnOrder;
  String? buildingGlobalId = '';

  @override
  void initState() {
    super.initState();

    String? entranceGlobalId =
        context.read<AttributesCubit>().currentEntranceGlobalId;
    buildingGlobalId = context.read<AttributesCubit>().currentBuildingGlobalId;

    // final id = widget.entranceGlobalId;
    _initialData['DwlEntGlobalID'] = entranceGlobalId;

    final schemaService = sl<SchemaService>();
    final dwellingSchema = schemaService.dwellingSchema;

    _columnLabels = {
      for (var attr in dwellingSchema.attributes) attr.name: attr.label.al,
    };

    _columnOrder = dwellingSchema.attributes
        .where((attr) => attr.display.enumerator != "none")
        .map((attr) => attr.name)
        .toList();

    // context.read<DwellingCubit>().getDwellings(globalId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DwellingCubit, DwellingState>(
      listener: (context, state) {
        if (state is Dwellings) {
          final dwellings = state.dwellings;

          // if (featuresRaw is List) {
          // final features = featuresRaw;
          setState(() {
            _dwellingRows.clear();
            _dwellingRows.addAll(dwellings);
          });
        }
        // } else if (state is DwellingAttributes) {
        //   setState(() {
        //     _dwellingSchema = state.attributes;
        //     _showDwellingForm = _viewPendingRow == null;
        //   });

        //   if (_viewPendingRow != null) {
        //     WidgetsBinding.instance.addPostFrameCallback((_) {
        //       _showViewDialog(_viewPendingRow!);
        //       _viewPendingRow = null;
        //     });
        //   }
        // } else if (state is DwellingError) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(state.message)),
        //   );
        // }
      },
      builder: (context, state) {
        return (state is Dwellings && state.showDwellingList)
            ? SideContainer(
                child: Scaffold(
                  appBar: null, // Removed AppBar
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main content that fits parent width
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              // Custom header replacing AppBar
                              _buildCustomHeader(),
                              const SizedBox(height: 16),
                              if (state is DwellingLoading)
                                const Center(
                                    child: CircularProgressIndicator()),
                              if (_dwellingRows.isEmpty &&
                                  state is! DwellingLoading)
                                Expanded(child: _buildEmptyState()),
                              if (_dwellingRows.isNotEmpty)
                                Expanded(child: _buildDwellingsList()),
                            ],
                          ),
                        ),
                        if (_showDwellingForm) ...[
                          const SizedBox(
                              width: 16), // Spacing when form is shown
                          Expanded(
                            flex: 1, // Takes 1/3 of available width
                            child: TabletElementAttribute(
                              schema: _dwellingSchema,
                              selectedShapeType: ShapeType.noShape,
                              entranceOutsideVisibleArea: false,
                              readOnly: false,
                              initialData: _initialData,
                              onClose: () {
                                setState(() {
                                  _showDwellingForm = false;
                                  _isEditMode = false;
                                });
                              },
                              save: (formValues) async {
                                await _onSaveDwelling(
                                    formValues, buildingGlobalId!);
                                setState(() {
                                  _showDwellingForm = false;
                                  _isEditMode = false;
                                });
                              },
                              startReviewing: () => {},
                              finishReviewing: () => {},
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildCustomHeader() {
    // Get the first dwelling's OBJECTID for display
    // final objectId = _dwellingRows.isNotEmpty
    //     ? _dwellingRows.first['OBJECTID']?.toString() ?? "N/A"
    //     : "N/A";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: handleOnClose,
              tooltip: 'Go Back',
            ),
            const SizedBox(width: 8),

            // Title and info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home, color: Colors.blue, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Dwellings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_dwellingRows.length} total',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   'Object ID: $objectId',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey[600],
                  //   ),
                  // ),
                ],
              ),
            ),

            // Add button
            ElevatedButton.icon(
              onPressed: _onAddNewDwelling,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Shto'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDwellingsList() {
    // Group dwellings by floor
    final groupedByFloor = _groupDwellingsByFloor();

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(4), // Reduced padding
        itemCount: groupedByFloor.keys.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 6), // Reduced spacing
        itemBuilder: (context, index) {
          final floor = groupedByFloor.keys.elementAt(index);
          final dwellings = groupedByFloor[floor]!;
          return _buildFloorGroup(floor, dwellings);
        },
      ),
    );
  }

  Widget _buildExpandableDwellingItem(DwellingEntity dwelling, int index) {
    final isExpanded = _expandedDwellings.contains(index);
    // final floor = dwelling['DwlFloor']?.toString() ?? 'N/A';
    final apartNumber = dwelling.dwlApartNumber?.toString() ?? 'N/A';
    final quality = dwelling.dwlQuality?.toString() ?? '0';
    final qualityInfo = _getQualityInfo(quality);

    return Card(
      elevation: isExpanded ? 3 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // Header - Always visible
          InkWell(
            onTap: () => _toggleExpansion(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Apartment info
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          apartNumber != 'N/A'
                              ? 'Apt $apartNumber'
                              : 'No Apartment',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quality status icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: qualityInfo['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          qualityInfo['icon'],
                          color: qualityInfo['color'],
                          size: 14,
                        ),
                        // const SizedBox(width: 4),
                        // Text(
                        //   quality,
                        //   style: TextStyle(
                        //     color: qualityInfo['color'],
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 11,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(dwelling, index),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(DwellingEntity dwelling, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),

          // Display all dwelling data
          _buildDwellingDataGrid(dwelling),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _onViewDwelling(dwelling),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Details'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _onEditDwelling(dwelling),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDwellingDataGrid(DwellingEntity dwelling) {
    // Define the properties to show with their corresponding entity fields
    final dataItems = <MapEntry<String, dynamic>>[];

    // Map the allowed keys to entity properties
    final propertyMap = {
      'DwlFloor': dwelling.dwlFloor,
      'DwlApartNumber': dwelling.dwlApartNumber,
      'DwlQuality': dwelling.dwlQuality,
    };

    // Only add non-null values in the specified order
    for (final key in _columnOrder) {
      if (propertyMap.containsKey(key) && propertyMap[key] != null) {
        dataItems.add(MapEntry(key, propertyMap[key]));
      }
    }

    return Wrap(
      spacing: 12, // Reduced spacing
      runSpacing: 8, // Reduced spacing
      children: dataItems.map((entry) {
        return _buildDataItem(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildDataItem(String key, dynamic value) {
    String displayValue = value?.toString() ?? 'N/A';
    String label = _columnLabels[key] ?? key;

    // Special handling for quality field
    if (key == 'DwlQuality') {
      const qualityLabels = {
        '1': 'Complete (No errors)',
        '2': 'Incomplete (Missing data)',
        '3': 'Conflicted (Contradictory)',
        '9': 'Untested',
        '0': 'Deleted',
      };
      displayValue = qualityLabels[displayValue] ?? displayValue;
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 100), // Reduced min width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10, // Smaller font
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 8, // Reduced padding
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 12, // Smaller font
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No dwellings found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first dwelling to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onAddNewDwelling,
            icon: const Icon(Icons.add),
            label: const Text('Add First Dwelling'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Map<String, List<DwellingEntity>> _groupDwellingsByFloor() {
    final grouped = <String, List<DwellingEntity>>{};

    for (final dwelling in _dwellingRows) {
      final floor = dwelling.dwlFloor?.toString() ?? 'Unknown';
      if (!grouped.containsKey(floor)) {
        grouped[floor] = [];
      }
      grouped[floor]!.add(dwelling);
    }

    // Sort floors numerically
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == 'Unknown') return 1;
        if (b == 'Unknown') return -1;
        final aNum = int.tryParse(a) ?? 0;
        final bNum = int.tryParse(b) ?? 0;
        return aNum.compareTo(bNum);
      });

    return Map.fromEntries(
        sortedKeys.map((key) => MapEntry(key, grouped[key]!)));
  }

  bool _floorHasErrors(List<DwellingEntity> dwellings) {
    return dwellings.any((dwelling) {
      final quality = dwelling.dwlQuality?.toString() ?? '0';
      return quality == '2' || quality == '3'; // Missing data or Contradictory
    });
  }

  Widget _buildFloorGroup(String floor, List<DwellingEntity> dwellings) {
    final isFloorExpanded = _expandedFloors.contains(floor);
    final hasErrors = _floorHasErrors(dwellings);

    return Card(
      elevation: isFloorExpanded ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Floor header
          InkWell(
            onTap: () => _toggleFloorExpansion(floor),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.apartment,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Floor $floor',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${dwellings.length} dwelling${dwellings.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Error flag
                  if (hasErrors) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red[700],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Issues',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: isFloorExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),

          // Floor content (dwellings)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildFloorContent(floor, dwellings),
            crossFadeState: isFloorExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorContent(String floor, List<DwellingEntity> dwellings) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 6),
          ...dwellings.asMap().entries.map((entry) {
            final dwelling = entry.value;
            final dwellingIndex = _dwellingRows
                .indexWhere((d) => d.globalId == dwelling.globalId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildExpandableDwellingItem(dwelling, dwellingIndex),
            );
          }),
        ],
      ),
    );
  }

  void _toggleFloorExpansion(String floor) {
    setState(() {
      if (_expandedFloors.contains(floor)) {
        _expandedFloors.remove(floor);
        // Also collapse all dwellings in this floor
        for (final dwelling in _dwellingRows) {
          if (dwelling.dwlFloor?.toString() == floor) {
            final index = _dwellingRows.indexOf(dwelling);
            _expandedDwellings.remove(index);
          }
        }
      } else {
        _expandedFloors.add(floor);
      }
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedDwellings.contains(index)) {
        _expandedDwellings.remove(index);
      } else {
        _expandedDwellings.add(index);
      }
    });
  }

  Map<String, dynamic> _getQualityInfo(String quality) {
    switch (quality) {
      case '1':
        return {
          'color': Colors.green,
          'icon': Icons.check_circle,
          'label': 'Complete',
        };
      case '2':
        return {
          'color': Colors.orange,
          'icon': Icons.warning,
          'label': 'Incomplete',
        };
      case '3':
        return {
          'color': Colors.red,
          'icon': Icons.error,
          'label': 'Conflicted',
        };
      case '9':
        return {
          'color': Colors.blue,
          'icon': Icons.help_outline,
          'label': 'Untested',
        };
      case '0':
      default:
        return {
          'color': Colors.grey,
          'icon': Icons.delete_outline,
          'label': 'Deleted',
        };
    }
  }

  void _onViewDwelling(DwellingEntity row) {
    if (_dwellingSchema.isEmpty) {
      _viewPendingRow = row;
      context.read<DwellingCubit>().getDwellingAttibutes();
      return;
    }
    _showViewDialog(row);
  }

  void _showViewDialog(DwellingEntity row) {
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
                  entranceOutsideVisibleArea: false,
                  initialData: row.toMap(),
                  onClose: () => Navigator.pop(context),
                  save: (_) async {},
                  readOnly: true,
                  startReviewing: () => {},
                  finishReviewing: () => {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditDwelling(DwellingEntity row) {
    context.read<DwellingCubit>().closeDwellings();
    // context.read<NewGeometryCubit>().setType(ShapeType.noShape);
    context.read<AttributesCubit>().showDwellingAttributes(row.objectId);
  }

  void handleOnClose() {
    context.read<DwellingCubit>().closeDwellings();
  }

  void _onAddNewDwelling() {
    context.read<DwellingCubit>().closeDwellings();
    // context.read<NewGeometryCubit>().setType(ShapeType.noShape);
    context.read<AttributesCubit>().showDwellingAttributes(null);
  }

  Future<void> _onSaveDwelling(
      Map<String, dynamic> attributes, String buildingGlobalId) async {
    if (_isEditMode) {
      //   await context
      //       .read<DwellingCubit>()
      //       .updateDwellingFeature(attributes, buildingGlobalId);
      // } else {
      //   await context
      //       .read<DwellingCubit>()
      //       .addDwellingFeature(attributes, buildingGlobalId);

      widget.onSave(attributes);
    }

    setState(() {
      _showDwellingForm = false;
      _isEditMode = false;
    });
  }
}

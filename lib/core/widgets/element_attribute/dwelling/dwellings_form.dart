import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/side_container.dart';
import 'package:asrdb/domain/entities/download_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
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
  static const String _unknownFloorKey = '_unknown';
  final List<DwellingEntity> _dwellingRows = [];
  List<FieldSchema> _dwellingSchema = [];
  bool _showDwellingForm = false;
  final Map<String, dynamic> _initialData = {};
  final Set<int> _expandedDwellings = {}; // Track which dwellings are expanded
  final Set<String> _expandedFloors = {}; // Track which floors are expanded

  late Map<String, String> _columnLabels;
  late List<String> _columnOrder;
  String _currentLanguage = 'sq'; // Default to Albanian
  // String? buildingGlobalId = '';

  String _getLocalizedLabel(dynamic attribute) {
    // Use cached language to avoid context access during build
    if (_currentLanguage == 'sq') {
      return attribute.label.al;
    } else {
      return attribute.label.en;
    }
  }

  @override
  void initState() {
    super.initState();

    String? entranceGlobalId =
        context.read<AttributesCubit>().currentEntranceGlobalId;
    // buildingGlobalId = context.read<AttributesCubit>().currentBuildingGlobalId;

    // final id = widget.entranceGlobalId;
    _initialData['DwlEntGlobalID'] = entranceGlobalId;

    final schemaService = sl<SchemaService>();
    final dwellingSchema = schemaService.dwellingSchema;

    _columnLabels = {
      for (var attr in dwellingSchema.attributes)
        attr.name: _getLocalizedLabel(attr),
    };

    _columnOrder = dwellingSchema.attributes
        .where((attr) => attr.display.enumerator != "none")
        .map((attr) => attr.name)
        .toList();

    // context.read<DwellingCubit>().getDwellings(globalId);
  }

  void handleOnClose() {
    // context.read<AttributesCubit>().clearAllSelections();
    // context.read<GeometryEditorCubit>().cancelOperation();
    // context.read<BuildingCubit>().clearSelectedBuilding();
    setState(() {
      _showDwellingForm = false;
    });
  }

  void handleBackToDwellingList() {
    context.read<DwellingCubit>().closeDwellings();

    String? entranceGlobalId =
        context.read<AttributesCubit>().currentEntranceGlobalId;
    String? buildingGlobalId =
        context.read<AttributesCubit>().currentBuildingGlobalId;

    context
        .read<AttributesCubit>()
        .showEntranceAttributes(entranceGlobalId, buildingGlobalId, false, 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update language when dependencies change (including locale changes)
    final newLanguage = Localizations.localeOf(context).languageCode;
    if (newLanguage != _currentLanguage) {
      setState(() {
        _currentLanguage = newLanguage;
        // Update column labels with new language
        final schemaService = sl<SchemaService>();
        final dwellingSchema = schemaService.dwellingSchema;
        _columnLabels = {
          for (var attr in dwellingSchema.attributes)
            attr.name: _getLocalizedLabel(attr),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DwellingCubit, DwellingState>(
      listener: (context, state) {
        if (state is Dwellings) {
          final dwellings = state.dwellings;

          setState(() {
            _dwellingRows.clear();
            _dwellingRows.addAll(dwellings);
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
                              onClose: handleOnClose,
                              save: (formValues) async {
                                await _onSaveDwelling(formValues);
                                // Don't clear selections when saving - only close the form
                                // Building should stay selected after saving entrance
                                setState(() {
                                  _showDwellingForm = false;
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

    final localizations = AppLocalizations.of(context);
    final totalLabel = localizations
        .translate(Keys.dwellingTotalLabel)
        .replaceFirst('{count}', _dwellingRows.length.toString());

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
              onPressed: handleBackToDwellingList,
              tooltip: localizations.translate(Keys.goBack),
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
                      Text(
                        AppLocalizations.of(context).translate(Keys.dwellings),
                        style: const TextStyle(
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
                          totalLabel,
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
              label: Text(AppLocalizations.of(context).translate(Keys.addNew)),
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
    final localizations = AppLocalizations.of(context);
    final apartNumber = dwelling.dwlApartNumber?.toString();
    final trimmedApartmentNumber = apartNumber?.trim();
    final hasApartmentNumber =
        trimmedApartmentNumber != null && trimmedApartmentNumber.isNotEmpty;
    final apartmentLabel = hasApartmentNumber
        ? localizations
            .translate(Keys.apartmentNumber)
            .replaceFirst('{number}', trimmedApartmentNumber)
        : localizations.translate(Keys.noApartment);
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
                          apartmentLabel,
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
                      color: qualityInfo['color'].withValues(alpha: 0.1),
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
              ElevatedButton.icon(
                onPressed: () => _onEditDwelling(dwelling),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(
                    AppLocalizations.of(context).translate(Keys.viewAndEdit)),
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
    final localizations = AppLocalizations.of(context);
    final rawValue = value?.toString();
    String displayValue;
    if (rawValue == null || rawValue.isEmpty) {
      displayValue = localizations.translate(Keys.notAvailable);
    } else {
      displayValue = rawValue;
    }
    String label = _columnLabels[key] ?? key;

    // Special handling for quality field
    if (key == 'DwlQuality' && rawValue != null && rawValue.isNotEmpty) {
      final qualityInfo = _getQualityInfo(rawValue);
      final qualityLabel = qualityInfo['label'] as String?;
      if (qualityLabel != null) {
        displayValue = qualityLabel;
      }
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
    final localizations = AppLocalizations.of(context);
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
            localizations.translate(Keys.noDwellingsFound),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.translate(Keys.addFirstDwellingPrompt),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onAddNewDwelling,
            icon: const Icon(Icons.add),
            label: Text(
                AppLocalizations.of(context).translate(Keys.addFirstDwelling)),
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
      final floorValue = dwelling.dwlFloor?.toString();
      final key = (floorValue == null || floorValue.isEmpty)
          ? _unknownFloorKey
          : floorValue;
      grouped.putIfAbsent(key, () => <DwellingEntity>[]);
      grouped[key]!.add(dwelling);
    }

    // Sort floors numerically in descending order (10 to 1)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == _unknownFloorKey) return 1;
        if (b == _unknownFloorKey) return -1;
        final aNum = int.tryParse(a) ?? 0;
        final bNum = int.tryParse(b) ?? 0;
        return bNum.compareTo(aNum);
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
    final localizations = AppLocalizations.of(context);
    final floorLabel = floor == _unknownFloorKey
        ? localizations.translate(Keys.unknown)
        : floor;
    final dwellingsCountKey = dwellings.length == 1
        ? Keys.dwellingCountSingle
        : Keys.dwellingCountPlural;
    final dwellingsCountLabel = localizations
        .translate(dwellingsCountKey)
        .replaceFirst('{count}', dwellings.length.toString());

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
                    '${localizations.translate(Keys.floor)} $floorLabel',
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
                      dwellingsCountLabel,
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
                            localizations.translate(Keys.issues),
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
          final dwellingFloorValue = dwelling.dwlFloor?.toString();
          final matchesFloor =
              dwellingFloorValue != null && dwellingFloorValue == floor;
          final isUnknownFloor =
              (dwellingFloorValue == null || dwellingFloorValue.isEmpty) &&
                  floor == _unknownFloorKey;
          if (matchesFloor || isUnknownFloor) {
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
    final localizations = AppLocalizations.of(context);

    switch (quality) {
      case '1':
        return {
          'color': Colors.green,
          'icon': Icons.check_circle,
          'label': localizations.translate(Keys.dwellingQualityComplete),
        };
      case '2':
        return {
          'color': Colors.orange,
          'icon': Icons.warning,
          'label': localizations.translate(Keys.dwellingQualityIncomplete),
        };
      case '3':
        return {
          'color': Colors.red,
          'icon': Icons.error,
          'label': localizations.translate(Keys.dwellingQualityConflicted),
        };
      case '9':
        return {
          'color': Colors.blue,
          'icon': Icons.help_outline,
          'label': localizations.translate(Keys.dwellingQualityUntested),
        };
      case '0':
      default:
        return {
          'color': Colors.grey,
          'icon': Icons.delete_outline,
          'label': localizations.translate(Keys.dwellingQualityDeleted),
        };
    }
  }

  void _onEditDwelling(DwellingEntity row) {
    context.read<DwellingCubit>().closeDwellings();
    bool isOffline = context.read<TileCubit>().isOffline;
    DownloadEntity? download = context.read<TileCubit>().download;
    context
        .read<AttributesCubit>()
        .showDwellingAttributes(row.objectId, isOffline, download?.id);
  }

  // void handleOnClose() {
  //   context.read<DwellingCubit>().closeDwellings();
  // }

  void _onAddNewDwelling() {
    context.read<DwellingCubit>().closeDwellings();
    // context.read<NewGeometryCubit>().setType(ShapeType.noShape);
    bool isOffline = context.read<TileCubit>().isOffline;
    DownloadEntity? download = context.read<TileCubit>().download;
    context
        .read<AttributesCubit>()
        .showDwellingAttributes(null, isOffline, download?.id);
  }

  Future<void> _onSaveDwelling(Map<String, dynamic> attributes) async {
    widget.onSave(attributes);

    setState(() {
      _showDwellingForm = false;
    });
  }
}

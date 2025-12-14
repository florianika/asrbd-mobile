import 'package:asrdb/core/db/street_database.dart';
import 'package:asrdb/core/enums/form_context.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/helpers/esri_type_conversion.dart';
import 'package:asrdb/core/models/attributes/attribute_schema.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/street/street.dart';
import 'package:asrdb/core/models/validation/validaton_result.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/chat/notes_modal.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class DynamicElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final bool entranceOutsideVisibleArea;
  final String? entranceGlobalId;
  final Map<String, dynamic>? initialData;
  final Future<void> Function(Map<String, dynamic>)? onSave;
  final void Function()? onClose;
  final void Function()? onEdit;
  final void Function()? onCancel;
  final bool readOnly;
  final bool showButtons;
  final List<ValidationResult>? validationResults;
  final List<LatLng>? entrancePointsOnMap;
  final LatLngBounds? visibleBounds;
  final FormContext formContext;

  const DynamicElementAttribute({
    required this.schema,
    required this.selectedShapeType,
    required this.entranceOutsideVisibleArea,
    this.entranceGlobalId,
    this.initialData,
    this.onSave,
    this.onClose,
    this.onEdit,
    this.onCancel,
    this.showButtons = true,
    this.readOnly = false,
    this.validationResults,
    this.entrancePointsOnMap,
    this.visibleBounds,
    this.formContext = FormContext.view,
    super.key,
  });

  @override
  DynamicElementAttributeState createState() => DynamicElementAttributeState();
}

class DynamicElementAttributeState extends State<DynamicElementAttribute> {
  final Map<String, dynamic> formValues = {};
  final Map<String, String?> validationErrors = {};
  final Map<String, TextEditingController> _controllers = {};
  String _currentLanguage = 'sq'; // Default to Albanian
  ValidationResult? _getValidationResult(String fieldName) {
    if (widget.validationResults == null) return null;
    return widget.validationResults!
        .where((result) => result.name == fieldName)
        .firstOrNull;
  }

  @override
  void initState() {
    super.initState();
    _initializeForm(widget.initialData ?? {});
  }

  @override
  void didUpdateWidget(covariant DynamicElementAttribute oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData &&
        widget.initialData != null) {
      _initializeForm(widget.initialData!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update language when dependencies change (including locale changes)
    final newLanguage = Localizations.localeOf(context).languageCode;
    if (newLanguage != _currentLanguage) {
      setState(() {
        _currentLanguage = newLanguage;
      });
    }
  }

  Future<void> _initializeForm(Map<String, dynamic> data) async {
    formValues
      ..clear()
      ..addAll(data);

    for (final field in widget.schema) {
      final key = field.name;
      final rawValue = data[key];
      final defaultValue = field.defaultValue?.toString() ?? '';
      final value = rawValue?.toString() ?? defaultValue;

      if (key == 'EntStrGlobalID' && rawValue != null) {
        final streetInfo = await StreetDatabase.getStreetByGlobalId(rawValue);
        final text = streetInfo?.strNameCore ?? '';
        _updateOrCreateController(key, text);
      } else if (key == 'EntTown' && rawValue != null) {
        // Find the town name from coded values
        final townName = _getTownNameFromCode(field, rawValue);
        _updateOrCreateController(key, townName);
      } else if (key == 'BldPermitDate' && rawValue != null) {
        // Format date for display
        DateTime? dateValue;
        if (rawValue is DateTime) {
          dateValue = rawValue;
        } else if (rawValue is String) {
          dateValue = DateTime.tryParse(rawValue);
        } else if (rawValue is int) {
          // Handle epoch milliseconds
          dateValue = DateTime.fromMillisecondsSinceEpoch(rawValue);
        }
        final formattedDate =
            dateValue != null ? DateFormat('dd/MM/yyyy').format(dateValue) : '';
        _updateOrCreateController(key, formattedDate);
      } else {
        _updateOrCreateController(key, value);
      }
    }

    setState(() {});
  }

  void _updateOrCreateController(String key, String value) {
    if (_controllers.containsKey(key)) {
      _controllers[key]!.text = value;
    } else {
      _controllers[key] = TextEditingController(text: value);
    }
  }

  String _getTownNameFromCode(FieldSchema field, dynamic code) {
    if (field.codedValues == null) return code.toString();

    final townOption = field.codedValues!.firstWhere(
      (option) => option['code'] == code,
      orElse: () => {'name': code.toString()},
    );

    return townOption['name'].toString();
  }

  String _getLocalizedLabel(dynamic attribute) {
    if (_currentLanguage == 'sq') {
      return attribute.label.al;
    } else {
      return attribute.label.en;
    }
  }

  String _getLocalizedDescription(dynamic attribute) {
    if (_currentLanguage == 'sq') {
      return attribute.description.al;
    } else {
      return attribute.description.en;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> handleSave() async {
    bool passedValidation = true;
    validationErrors.clear();

    final schemaService = sl<SchemaService>();
    AttributeSchema schemaItems = schemaService.entranceSchema;

    if (widget.selectedShapeType == ShapeType.polygon) {
      schemaItems = schemaService.buildingSchema;
    } else if (widget.selectedShapeType == ShapeType.noShape) {
      schemaItems = schemaService.dwellingSchema;
    }

    for (final attribute in schemaItems.attributes) {
      final itemFound =
          widget.schema.firstWhereOrNull((x) => x.name == attribute.name);

      if (itemFound == null) continue;

      final value = formValues[itemFound.name];
      if (attribute.required && (value == null || value.toString().isEmpty)) {
        passedValidation = false;
        final localizedMessage =
            AppLocalizations.of(context).translate(Keys.fieldRequired);

        validationErrors[itemFound.name] =
            localizedMessage.replaceAll('{fieldName}', itemFound.alias);
      }
    }

    setState(() {});

    if (passedValidation && widget.onSave != null) {
      await widget.onSave!(formValues);
    }
  }

  String _getHeaderTitle() {
    String baseTitleKey;
    switch (widget.selectedShapeType) {
      case ShapeType.polygon:
        baseTitleKey = Keys.building;
        break;
      case ShapeType.point:
        baseTitleKey = Keys.entrance;
        break;
      case ShapeType.noShape:
        baseTitleKey = Keys.dwelling;
        break;
    }

    String actionKey;
    switch (widget.formContext) {
      case FormContext.view:
        actionKey = Keys.view;
        break;
      case FormContext.edit:
        actionKey = Keys.edit;
        break;
      case FormContext.add:
        actionKey = Keys.add;
        break;
    }

    final baseTitle = AppLocalizations.of(context).translate(baseTitleKey);
    final action = AppLocalizations.of(context).translate(actionKey);
    return '$action $baseTitle';
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _getHeaderTitle(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<dynamic>> _groupAttributesBySection() {
    final schemaService = sl<SchemaService>();
    AttributeSchema schema = schemaService.entranceSchema;

    if (widget.selectedShapeType == ShapeType.polygon) {
      schema = schemaService.buildingSchema;
    } else if (widget.selectedShapeType == ShapeType.noShape) {
      schema = schemaService.dwellingSchema;
    }

    final sectionOrder = ['title', 'identification', 'description', 'history'];
    Map<String, List<dynamic>> sections = {};
    for (String sectionName in sectionOrder) {
      sections[sectionName] = [];
    }

    for (var attribute in schema.attributes) {
      if (attribute.display.enumerator == "none") continue;

      final elementFound = widget.schema
          .where((x) => x.name.toLowerCase() == attribute.name.toLowerCase())
          .firstOrNull;

      if (elementFound == null) {
        continue;
      }
      String sectionName = attribute.section; // ?? "General";
      if (sections.containsKey(sectionName)) {
        sections[sectionName]!.add({
          'attribute': attribute,
          'element': elementFound,
        });
      }
    }
    sections.removeWhere((key, value) => value.isEmpty);

    return sections;
  }

  Widget _buildSectionHeader(String sectionName) {
    IconData getSectionIcon(String section) {
      switch (section.toLowerCase()) {
        case 'title':
          return Icons.title;
        case 'identification':
          return Icons.badge;
        case 'map':
          return Icons.map;
        case 'description':
          return Icons.info_outline;
        case 'history':
          return Icons.history;
        default:
          return Icons.folder;
      }
    }

    const sectionColor = Colors.black;
    final localizations = AppLocalizations.of(context);
    String localizedSectionName;
    switch (sectionName.toLowerCase()) {
      case 'title':
        localizedSectionName = localizations.translate(Keys.sectionTitle);
        break;
      case 'identification':
        localizedSectionName =
            localizations.translate(Keys.sectionIdentification);
        break;
      case 'description':
        localizedSectionName = localizations.translate(Keys.sectionDescription);
        break;
      default:
        localizedSectionName = sectionName.toUpperCase();
    }

    if (localizedSectionName == Keys.sectionTitle ||
        localizedSectionName == Keys.sectionIdentification ||
        localizedSectionName == Keys.sectionDescription) {
      localizedSectionName = sectionName.toUpperCase();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        children: [
          Icon(
            getSectionIcon(sectionName),
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 10),
          Text(
            localizedSectionName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: sectionColor,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: sectionColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(dynamic attribute, dynamic elementFound) {
    final validationResult = _getValidationResult(elementFound.name);
    final isReadOnly =
        widget.formContext.isReadOnly || attribute.display.enumerator == "read";
    final isEditMode = widget.formContext == FormContext.edit;

    return InputDecoration(
      labelText: '${_getLocalizedLabel(attribute)} (${attribute.name})',
      labelStyle: TextStyle(
        color: isReadOnly ? Colors.grey[500] : Colors.grey[600],
        fontSize: 14,
      ),
      errorText: validationErrors[elementFound.name],
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      filled: true,
      fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
      suffixIcon: validationResult != null
          ? Icon(
              Icons.priority_high,
              color: validationResult.level == ValidationLevel.error
                  ? Colors.red
                  : validationResult.level == ValidationLevel.info
                      ? Colors.green
                      : Colors.orange,
              size: 20,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: validationResult != null
              ? (validationResult.level == ValidationLevel.error
                  ? Colors.red
                  : validationResult.level == ValidationLevel.info
                      ? Colors.green
                      : Colors.orange)
              : (isEditMode ? Colors.grey[700]! : Colors.grey[300]!),
          width: validationResult != null ? 1.5 : (isEditMode ? 2 : 1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: validationResult != null
              ? (validationResult.level == ValidationLevel.error
                  ? Colors.red
                  : validationResult.level == ValidationLevel.info
                      ? Colors.green
                      : Colors.orange)
              : (isEditMode ? Colors.grey[700]! : Colors.grey[300]!),
          width: validationResult != null ? 1.5 : (isEditMode ? 2 : 1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: validationResult != null
              ? (validationResult.level == ValidationLevel.error
                  ? Colors.red
                  : Colors.orange)
              : (isEditMode ? Colors.grey[800]! : Colors.grey[600]!),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isReadOnly ? Colors.grey[400]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildStreetTypeAhead(dynamic attribute, dynamic elementFound) {
    final validationResult = _getValidationResult(elementFound.name);
    final localizations = AppLocalizations.of(context);

    return Tooltip(
      message: _getLocalizedDescription(attribute),
      preferBelow: false,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField<Street>(
            key: ValueKey(elementFound.name),
            controller: _controllers[elementFound.name],
            builder: (context, controller, focusNode) {
              return MouseRegion(
                cursor: (widget.formContext.isReadOnly ||
                        attribute.display.enumerator == "read")
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.text,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: widget.formContext.isReadOnly ||
                      attribute.display.enumerator == "read",
                  enabled:
                      !widget.formContext.isReadOnly && elementFound.editable,
                  decoration:
                      _getInputDecoration(attribute, elementFound).copyWith(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (validationResult != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.priority_high,
                              color: validationResult.level ==
                                      ValidationLevel.error
                                  ? Colors.red
                                  : validationResult.level ==
                                          ValidationLevel.info
                                      ? Colors.green
                                      : Colors.orange,
                              size: 16,
                            ),
                          ),
                        if (controller.text.isNotEmpty &&
                            !widget.formContext.isReadOnly)
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              controller.clear();
                              formValues[elementFound.name] = null;
                              focusNode.requestFocus();
                            },
                          )
                        else
                          Icon(Icons.location_on, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                  style: TextStyle(
                    color: (widget.formContext.isReadOnly ||
                            attribute.display.enumerator == "read")
                        ? Colors.grey[600]
                        : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.length < 2) return [];
              final data =
                  await StreetDatabase.searchStreetsFTS(pattern, limit: 10);
              return data;
            },
            itemBuilder: (context, street) {
              final typeLabel = localizations.translate(Keys.streetTypeLabel);
              final idLabel = localizations.translate(Keys.streetIdLabel);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            street.strNameCore,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$typeLabel: ${street.strType} • $idLabel: ${street.globalId}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 14,
                    ),
                  ],
                ),
              );
            },
            onSelected: (street) {
              formValues[elementFound.name] = street.globalId;
              _controllers[elementFound.name]!.text = street.strNameCore;
              setState(() {
                validationErrors.remove(elementFound.name);
              });
            },
            constraints: const BoxConstraints(maxHeight: 250),
            offset: const Offset(0, 5),
            animationDuration: const Duration(milliseconds: 300),
            hideOnEmpty: true,
            hideOnError: true,
            hideOnLoading: false,
            debounceDuration: const Duration(milliseconds: 300),
            errorBuilder: (context, error) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations.translate(Keys.streetLoadError),
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      localizations.translate(Keys.streetLoading),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            emptyBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, color: Colors.grey[500], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      localizations.translate(Keys.streetEmpty),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            decorationBuilder: (context, child) {
              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                shadowColor: Colors.black.withValues(alpha: 0.1),
                child: child,
              );
            },
          ),
          if (validationResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Row(
                children: [
                  Icon(
                    validationResult.level == ValidationLevel.error
                        ? Icons.error_outline
                        : validationResult.level == ValidationLevel.info
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                    color: validationResult.level == ValidationLevel.error
                        ? Colors.red
                        : validationResult.level == ValidationLevel.info
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validationResult.message,
                      style: TextStyle(
                        color: validationResult.level == ValidationLevel.error
                            ? Colors.red
                            : validationResult.level == ValidationLevel.info
                                ? Colors.green
                                : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTownTypeAhead(dynamic attribute, dynamic elementFound) {
    final validationResult = _getValidationResult(elementFound.name);
    final localizations = AppLocalizations.of(context);

    // Get the coded values for towns from the field schema
    final allTownOptions = elementFound.codedValues ?? [];

    // Filter towns based on municipality
    final userService = sl<UserService>();
    final municipalityId = userService.userInfo?.municipality;

    final townOptions = municipalityId != null
        ? allTownOptions.where((town) {
            final townCode = town['code'] as int?;
            if (townCode == null) return false;

            // Filter based on: municipalityId*10000 <= code < (municipalityId+1)*10000
            final minCode = municipalityId * 10000;
            final maxCode = (municipalityId + 1) * 10000;
            return townCode >= minCode && townCode < maxCode;
          }).toList()
        : allTownOptions;

    return Tooltip(
      message: _getLocalizedDescription(attribute),
      preferBelow: false,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField<Map<String, dynamic>>(
            key: ValueKey(elementFound.name),
            controller: _controllers[elementFound.name],
            builder: (context, controller, focusNode) {
              return MouseRegion(
                cursor: (widget.formContext.isReadOnly ||
                        attribute.display.enumerator == "read")
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.text,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: widget.formContext.isReadOnly ||
                      attribute.display.enumerator == "read",
                  enabled:
                      !widget.formContext.isReadOnly && elementFound.editable,
                  decoration:
                      _getInputDecoration(attribute, elementFound).copyWith(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (validationResult != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.priority_high,
                              color: validationResult.level ==
                                      ValidationLevel.error
                                  ? Colors.red
                                  : validationResult.level ==
                                          ValidationLevel.info
                                      ? Colors.green
                                      : Colors.orange,
                              size: 16,
                            ),
                          ),
                        if (controller.text.isNotEmpty &&
                            !widget.formContext.isReadOnly)
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              controller.clear();
                              formValues[elementFound.name] = null;
                              focusNode.requestFocus();
                            },
                          )
                        else
                          Icon(Icons.location_city, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                  style: TextStyle(
                    color: (widget.formContext.isReadOnly ||
                            attribute.display.enumerator == "read")
                        ? Colors.grey[600]
                        : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.length < 1) return townOptions;

              // Filter towns based on the search pattern
              return townOptions.where((town) {
                final townName = town['name'].toString().toLowerCase();
                final searchPattern = pattern.toLowerCase();
                return townName.contains(searchPattern);
              }).toList();
            },
            itemBuilder: (context, town) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city_outlined,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        town['name'].toString(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 14,
                    ),
                  ],
                ),
              );
            },
            onSelected: (town) {
              formValues[elementFound.name] = town['code'];
              _controllers[elementFound.name]!.text = town['name'].toString();
              setState(() {
                validationErrors.remove(elementFound.name);
              });
            },
            constraints: const BoxConstraints(maxHeight: 250),
            offset: const Offset(0, 5),
            animationDuration: const Duration(milliseconds: 300),
            hideOnEmpty: false,
            hideOnError: true,
            hideOnLoading: false,
            debounceDuration: const Duration(milliseconds: 300),
            errorBuilder: (context, error) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations.translate(Keys.townLoadError),
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      localizations.translate(Keys.townLoading),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            emptyBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, color: Colors.grey[500], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      localizations.translate(Keys.townEmpty),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            decorationBuilder: (context, child) {
              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                shadowColor: Colors.black.withValues(alpha: 0.1),
                child: child,
              );
            },
          ),
          if (validationResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Row(
                children: [
                  Icon(
                    validationResult.level == ValidationLevel.error
                        ? Icons.error_outline
                        : validationResult.level == ValidationLevel.info
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                    color: validationResult.level == ValidationLevel.error
                        ? Colors.red
                        : validationResult.level == ValidationLevel.info
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validationResult.message,
                      style: TextStyle(
                        color: validationResult.level == ValidationLevel.error
                            ? Colors.red
                            : validationResult.level == ValidationLevel.info
                                ? Colors.green
                                : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(dynamic attribute, dynamic elementFound) {
    final validationResult = _getValidationResult(elementFound.name);
    // Ensure controller exists in the map
    if (!_controllers.containsKey(elementFound.name)) {
      _controllers[elementFound.name] = TextEditingController();
    }
    final controller = _controllers[elementFound.name]!;

    // Parse current date from controller text
    DateTime? selectedDate;
    if (controller.text.isNotEmpty) {
      selectedDate = DateFormat('dd/MM/yyyy').tryParse(controller.text);
    }

    // Get initial date from form values if available
    if (selectedDate == null && formValues[elementFound.name] != null) {
      final rawValue = formValues[elementFound.name];
      if (rawValue is DateTime) {
        selectedDate = rawValue;
      } else if (rawValue is String) {
        selectedDate = DateTime.tryParse(rawValue);
      } else if (rawValue is int) {
        selectedDate = DateTime.fromMillisecondsSinceEpoch(rawValue);
      }
    }

    return Tooltip(
      message: _getLocalizedDescription(attribute),
      preferBelow: false,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: (widget.formContext.isReadOnly ||
                    attribute.display.enumerator == "read")
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: InkWell(
              onTap: (!widget.formContext.isReadOnly && elementFound.editable)
                  ? () async {
                      // Show date picker, only allowing dates up to today (previous dates)
                      final DateTime now = DateTime.now();
                      final DateTime firstDate = DateTime(1900, 1, 1);
                      final DateTime lastDate =
                          DateTime(now.year, now.month, now.day);

                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? lastDate,
                        firstDate: firstDate,
                        lastDate:
                            lastDate, // Only allow previous dates (up to today)
                        helpText: _getLocalizedLabel(attribute),
                        cancelText:
                            AppLocalizations.of(context).translate(Keys.cancel),
                        confirmText: AppLocalizations.of(context)
                            .translate(Keys.confirmationConfirm),
                      );

                      if (picked != null) {
                        final formattedDate =
                            DateFormat('dd/MM/yyyy').format(picked);
                        controller.text = formattedDate;
                        // Store as DateTime in formValues
                        formValues[elementFound.name] = picked;
                        setState(() {
                          validationErrors.remove(elementFound.name);
                        });
                      }
                    }
                  : null,
              child: InputDecorator(
                decoration:
                    _getInputDecoration(attribute, elementFound).copyWith(
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: (widget.formContext.isReadOnly ||
                            attribute.display.enumerator == "read")
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 20,
                  ),
                ),
                child: Text(
                  controller.text.isEmpty
                      ? _getLocalizedLabel(attribute)
                      : controller.text,
                  style: TextStyle(
                    color: (widget.formContext.isReadOnly ||
                            attribute.display.enumerator == "read")
                        ? Colors.grey[600]
                        : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          if (validationResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Row(
                children: [
                  Icon(
                    validationResult.level == ValidationLevel.error
                        ? Icons.error_outline
                        : validationResult.level == ValidationLevel.info
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                    color: validationResult.level == ValidationLevel.error
                        ? Colors.red
                        : validationResult.level == ValidationLevel.info
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validationResult.message,
                      style: TextStyle(
                        color: validationResult.level == ValidationLevel.error
                            ? Colors.red
                            : validationResult.level == ValidationLevel.info
                                ? Colors.green
                                : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyLabel(dynamic attribute, dynamic elementFound) {
    final validationResult = _getValidationResult(elementFound.name);

    // Get the display value
    String displayValue = '';
    if (elementFound.codedValues != null) {
      // For coded values, find the name that matches the code
      final currentValue =
          formValues[elementFound.name] ?? elementFound.defaultValue;
      final codedValue = elementFound.codedValues!.firstWhere(
        (code) => code['code'] == currentValue,
        orElse: () => {'name': currentValue?.toString() ?? ''},
      );
      displayValue = codedValue['name'].toString();
    } else {
      displayValue = formValues[elementFound.name]?.toString() ??
          elementFound.defaultValue?.toString() ??
          '';
    }

    return Tooltip(
      message: _getLocalizedDescription(attribute),
      preferBelow: false,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getLocalizedLabel(attribute)}:',
                  key: ValueKey('${elementFound.name}_label'),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayValue,
                    key: ValueKey(elementFound.name),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (validationResult != null)
                  Icon(
                    Icons.priority_high,
                    color: validationResult.level == ValidationLevel.error
                        ? Colors.red
                        : validationResult.level == ValidationLevel.info
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
              ],
            ),
          ),
          if (validationResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Row(
                children: [
                  Icon(
                    validationResult.level == ValidationLevel.error
                        ? Icons.error_outline
                        : validationResult.level == ValidationLevel.info
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                    color: validationResult.level == ValidationLevel.error
                        ? Colors.red
                        : validationResult.level == ValidationLevel.info
                            ? Colors.green
                            : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validationResult.message,
                      style: TextStyle(
                        color: validationResult.level == ValidationLevel.error
                            ? Colors.red
                            : validationResult.level == ValidationLevel.info
                                ? Colors.green
                                : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField(
      dynamic attribute, dynamic elementFound, String sectionName) {
    final validationResult = _getValidationResult(elementFound.name);

    // If the field is read-only, render as a bold label
    if (attribute.display.enumerator == "read") {
      return _buildReadOnlyLabel(attribute, elementFound);
    }

    if (sectionName.toLowerCase() == 'history') {
      return Tooltip(
        message: _getLocalizedDescription(attribute),
        preferBelow: false,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                      color: validationResult != null
                      ? (validationResult.level == ValidationLevel.error
                          ? Colors.red
                          : validationResult.level == ValidationLevel.info
                              ? Colors.green
                              : Colors.orange)
                      : Colors.grey[200]!,
                  width: validationResult != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getLocalizedLabel(attribute)}:',
                    key: ValueKey('${elementFound.name}_label'),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${formValues[elementFound.name] ?? elementFound.defaultValue ?? ''}',
                      key: ValueKey(elementFound.name),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (validationResult != null)
                    Icon(
                      Icons.priority_high,
                      color: validationResult.level == ValidationLevel.error
                          ? Colors.red
                          : Colors.orange,
                      size: 16,
                    ),
                ],
              ),
            ),
            if (validationResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Row(
                  children: [
                    Icon(
                      validationResult.level == ValidationLevel.error
                          ? Icons.error_outline
                          : validationResult.level == ValidationLevel.info
                              ? Icons.info_outline
                              : Icons.warning_amber_outlined,
                      color: validationResult.level == ValidationLevel.error
                          ? Colors.red
                          : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        validationResult.message,
                        style: TextStyle(
                          color: validationResult.level == ValidationLevel.error
                              ? Colors.red
                              : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    if (elementFound.name == 'EntStrGlobalID') {
      return _buildStreetTypeAhead(attribute, elementFound);
    }

    if (elementFound.name == 'EntTown') {
      return _buildTownTypeAhead(attribute, elementFound);
    }

    if (elementFound.name == 'BldPermitDate') {
      return _buildDatePicker(attribute, elementFound);
    }

    final inputDecoration = _getInputDecoration(attribute, elementFound);

    if (elementFound.codedValues != null) {
      return Tooltip(
        message: _getLocalizedDescription(attribute),
        preferBelow: false,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              cursor: (widget.formContext.isReadOnly ||
                      attribute.display.enumerator == "read")
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: AbsorbPointer(
                absorbing: attribute.display.enumerator == "read",
                child: DropdownButtonFormField<Object?>(
                  key: ValueKey('${elementFound.name}_${widget.hashCode}'),
                  isExpanded: true,
                  decoration: inputDecoration,
                  value: () {
                    // Get the intended value
                    final intendedValue =
                        widget.initialData![elementFound.name] ??
                            elementFound.defaultValue;

                    // Check if this value exists in codedValues
                    final availableCodes = elementFound.codedValues!
                        .map((code) => code['code'])
                        .toSet();

                    // Only return the value if it exists in the dropdown items
                    return availableCodes.contains(intendedValue)
                        ? intendedValue
                        : null;
                  }(),
                  items: elementFound.codedValues!
                      .map<DropdownMenuItem<Object?>>(
                          (code) => DropdownMenuItem<Object?>(
                                key: ValueKey(
                                    '${elementFound.name}_${code['name']}_${widget.hashCode}'),
                                value: code['code'],
                                child: Text(
                                  code['name'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: (widget.formContext.isReadOnly ||
                                              attribute.display.enumerator ==
                                                  "read")
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                      fontSize: 14),
                                ),
                              ))
                      .toList(),
                  onChanged:
                      (!widget.formContext.isReadOnly && elementFound.editable)
                          ? (val) => formValues[elementFound.name] =
                              EsriTypeConversion.convert(elementFound.type, val)
                          : null,
                  disabledHint: Text(
                    formValues[elementFound.name]?.toString() ??
                        _getLocalizedLabel(attribute),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  style: TextStyle(
                    color: (widget.formContext.isReadOnly ||
                            attribute.display.enumerator == "read")
                        ? Colors.grey[600]
                        : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (validationResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Row(
                  children: [
                    Icon(
                      validationResult.level == ValidationLevel.error
                          ? Icons.error_outline
                          : validationResult.level == ValidationLevel.info
                              ? Icons.info_outline
                              : Icons.warning_amber_outlined,
                      color: validationResult.level == ValidationLevel.error
                          ? Colors.red
                          : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        validationResult.message,
                        style: TextStyle(
                          color: validationResult.level == ValidationLevel.error
                              ? Colors.red
                              : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    return Tooltip(
      message: _getLocalizedDescription(attribute),
      preferBelow: false,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: (widget.formContext.isReadOnly ||
                    attribute.display.enumerator == "read")
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.text,
            child: TextFormField(
              key: ValueKey(elementFound.name),
              controller: _controllers[elementFound.name],
              readOnly: widget.formContext.isReadOnly ||
                  attribute.display.enumerator == "read",
              enabled: !widget.formContext.isReadOnly && elementFound.editable,
              decoration: inputDecoration,
              style: TextStyle(
                color: (widget.formContext.isReadOnly ||
                        attribute.display.enumerator == "read")
                    ? Colors.grey[600]
                    : Colors.black87,
                fontSize: 14,
              ),
              onChanged:
                  (!widget.formContext.isReadOnly && elementFound.editable)
                      ? (val) => formValues[elementFound.name] =
                          EsriTypeConversion.convert(elementFound.type, val)
                      : null,
            ),
          ),
          if (validationResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Row(
                children: [
                  Icon(
                    validationResult.level == ValidationLevel.error
                        ? Icons.error_outline
                        : validationResult.level == ValidationLevel.info
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                      color: validationResult.level == ValidationLevel.error
                          ? Colors.red
                          : validationResult.level == ValidationLevel.info
                              ? Colors.green
                              : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validationResult.message,
                      style: TextStyle(
                        color: validationResult.level == ValidationLevel.error
                            ? Colors.red
                            : validationResult.level == ValidationLevel.info
                                ? Colors.green
                                : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final sections = _groupAttributesBySection();

    return Stack(
      children: [
        if (widget.selectedShapeType == ShapeType.polygon &&
            widget.entranceOutsideVisibleArea)
          Positioned(
            top: 10,
            left: 0,
            child: Tooltip(
              message: localizations.translate(Keys.entranceFarWarning),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color.fromARGB(255, 247, 174, 3),
                size: 25,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              _buildHeader(),
              ...sections.entries.map((sectionEntry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(sectionEntry.key),
                    ...sectionEntry.value.map<Widget>((attributeItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildFormField(
                          attributeItem['attribute'],
                          attributeItem['element'],
                          sectionEntry.key,
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
        if (widget.selectedShapeType == ShapeType.polygon)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.comment, size: 20, color: Colors.grey),
              tooltip: localizations.translate(Keys.comments),
              onPressed: () => showNotesForm(context: context),
            ),
          ),
      ],
    );
  }
}

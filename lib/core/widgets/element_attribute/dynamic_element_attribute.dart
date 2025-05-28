import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_type_conversion.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';

class DynamicElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final String? entranceGlobalId;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>)? onSave;
  final void Function()? onClose;
  final void Function(String?)? onDwelling;
  final bool readOnly;
  final bool showButtons; // New parameter to control button visibility

  const DynamicElementAttribute({
    required this.schema,
    required this.selectedShapeType,
    this.entranceGlobalId,
    this.initialData,
    this.onSave,
    this.onClose,
    this.onDwelling,
    this.showButtons = true, // Default to true for backward compatibility
    this.readOnly=false,
    super.key,
  });

  @override
  DynamicElementAttributeState createState() => DynamicElementAttributeState();
}

class DynamicElementAttributeState extends State<DynamicElementAttribute> {
  final Map<String, dynamic> formValues = {};
  final Map<String, String?> validationErrors = {};
  final Map<String, TextEditingController> _controllers = {};

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

  void _initializeForm(Map<String, dynamic> data) {
    formValues.clear();
    formValues.addAll(data);

    for (var field in widget.schema) {
      final value = data[field.name]?.toString() ??
          (field.defaultValue != null ? field.defaultValue.toString() : '');
      if (_controllers.containsKey(field.name)) {
        _controllers[field.name]!.text = value;
      } else {
        _controllers[field.name] = TextEditingController(text: value);
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void handleSave() {
    bool passedValidation = true;
    validationErrors.clear();

    final schemaService = sl<SchemaService>();
    final schemaItems = widget.selectedShapeType == ShapeType.point
        ? schemaService.entranceSchema
        : widget.selectedShapeType == ShapeType.polygon
            ? schemaService.buildingSchema
            : schemaService.dwellingSchema;

    schemaItems.attributes.map((attribute) {
      final itemFound =
          widget.schema.where((x) => x.name == attribute.name).first;

      final value = formValues[itemFound.name];
      if (!itemFound.nullable && (value == null || value.toString().isEmpty)) {
        passedValidation = false;
        validationErrors[itemFound.name] =
            '${attribute.label.al} duhet plotesuar';

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('${attribute.label.al} duhet plotesuar')),
        // );
      }
    });

    setState(() {});

    if (passedValidation && widget.onSave != null) {
      
      widget.onSave!(formValues);
    }
  }

  // Group attributes by section with specific ordering
  Map<String, List<dynamic>> _groupAttributesBySection() {
    final schemaService = sl<SchemaService>();
    final schema = widget.selectedShapeType == ShapeType.point
        ? schemaService.entranceSchema
        : (widget.selectedShapeType == ShapeType.polygon
            ? schemaService.buildingSchema
            : schemaService.dwellingSchema);

    // Define section order
    final sectionOrder = [
      'title',
      'technical',
      'identifier',
      'map',
      'info',
      'history'
    ];
    Map<String, List<dynamic>> sections = {};

    // Initialize sections in the correct order
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

      // Get section name, default to "General" if no section specified
      String sectionName = attribute.section ?? "General";

      // Only add to sections if it's in our predefined list
      if (sections.containsKey(sectionName)) {
        sections[sectionName]!.add({
          'attribute': attribute,
          'element': elementFound,
        });
      }
    }

    // Remove empty sections
    sections.removeWhere((key, value) => value.isEmpty);

    return sections;
  }

  Widget _buildSectionHeader(String sectionName) {
    IconData getSectionIcon(String section) {
      switch (section.toLowerCase()) {
        case 'title':
          return Icons.title;
        case 'technical':
          return Icons.settings;
        case 'identifier':
          return Icons.badge;
        case 'map':
          return Icons.map;
        case 'info':
          return Icons.info_outline;
        case 'history':
          return Icons.history;
        default:
          return Icons.folder;
      }
    }

    const sectionColor = Colors.black;

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
            sectionName.toUpperCase(),
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

  Widget _buildFormField(
    dynamic attribute, dynamic elementFound, String sectionName) {
  // For title and info sections, always display as text
  if (sectionName.toLowerCase() == 'title' ||
      sectionName.toLowerCase() == 'history') {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${attribute.label.al}:',
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
        ],
      ),
    );
  }

  final inputDecoration = InputDecoration(
    labelText: attribute.label.al,
    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
    errorText: validationErrors[elementFound.name],
    errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    filled: true,
    fillColor: widget.readOnly ? Colors.grey[100] : Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
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
      borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
    ),
  );

  // Dropdown field
  if (elementFound.codedValues != null) {
    return DropdownButtonFormField<Object?>(
      key: ValueKey(elementFound.name),
      isExpanded: true,
      decoration: inputDecoration,
      value: widget.initialData![elementFound.name] ?? elementFound.defaultValue,
      items: elementFound.codedValues!
          .map<DropdownMenuItem<Object?>>((code) => DropdownMenuItem<Object?>(
                value: code['code'],
                child: Text(
                  code['name'].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ))
          .toList(),
      onChanged: (!widget.readOnly && elementFound.editable)
          ? (val) => formValues[elementFound.name] =
              EsriTypeConversion.convert(elementFound.type, val)
          : null,
      disabledHint: Text(
        formValues[elementFound.name]?.toString() ??
            attribute.label.al,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      style: const TextStyle(color: Colors.black87, fontSize: 14),
    );
  }

  // Text field
  return TextFormField(
    key: ValueKey(elementFound.name),
    controller: _controllers[elementFound.name],
    readOnly: widget.readOnly || attribute.display.enumerator == "read",
    enabled: !widget.readOnly && elementFound.editable,
    decoration: inputDecoration,
    style: const TextStyle(color: Colors.black87, fontSize: 14),
    onChanged: (!widget.readOnly && elementFound.editable)
        ? (val) => formValues[elementFound.name] =
            EsriTypeConversion.convert(elementFound.type, val)
        : null,
  );
}

  @override
  Widget build(BuildContext context) {
    final sections = _groupAttributesBySection();

    return Column(
      children: [
        // Build sections with headers
        ...sections.entries.map((sectionEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(sectionEntry.key),
              ...sectionEntry.value.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildFormField(
                      item['attribute'], item['element'], sectionEntry.key),
                );
              }),
            ],
          );
        }),       
      ],
    );
  }
}

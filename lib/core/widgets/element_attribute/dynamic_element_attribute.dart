import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_type_conversion.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
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

  const DynamicElementAttribute({
    required this.schema,
    required this.selectedShapeType,
    this.entranceGlobalId,
    this.initialData,
    this.onSave,
    this.onClose,
    this.onDwelling,
    super.key,
  });

  @override
  State<DynamicElementAttribute> createState() =>
      _DynamicElementAttributeFormState();
}

class _DynamicElementAttributeFormState extends State<DynamicElementAttribute> {
  final Map<String, dynamic> formValues = {};
  final Map<String, String?> validationErrors = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    widget.schema.removeWhere(
        (field) => EntranceFields.hiddenAttributes.contains(field.name));
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

  void _handleSave() {
    bool passedValidation = true;
    validationErrors.clear();

    for (var field in widget.schema) {
      final value = formValues[field.name];
      if (!field.nullable && (value == null || value.toString().isEmpty)) {
        passedValidation = false;
        validationErrors[field.name] = '${field.alias} is required';
      }
    }

    setState(() {});

    if (passedValidation && widget.onSave != null) {
      widget.onSave!(formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    final schemaService = sl<SchemaService>();
    final schema = widget.selectedShapeType == ShapeType.point
        ? schemaService.entranceSchema
        : widget.selectedShapeType == ShapeType.polygon
            ? schemaService.buildingSchema
            : schemaService.dwellingSchema;

    return Column(
      children: [
        ...schema.attributes.map((attribute) {
          if (attribute.display.enumerator != "none") {
            final elementFound = widget.schema
                .where((x) => x.name == attribute.name)
                .firstOrNull;
            if (elementFound == null) {
              return const SizedBox();
            }

            if (elementFound.type == "codedValue") {
              return AbsorbPointer(
                absorbing: attribute.display.enumerator == "read",
                child: DropdownButtonFormField(
                  key: ValueKey(elementFound.name),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: elementFound.alias,
                    labelStyle: const TextStyle(color: Colors.black),
                    errorText: validationErrors[elementFound.name],
                  ),
                  value: elementFound,
                  items: elementFound.codedValues!
                      .map((code) => DropdownMenuItem(
                            value: code['code'],
                            child: Text(
                              code['name'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: elementFound.editable
                      ? (val) => formValues[elementFound.name] =
                          EsriTypeConversion.convert(elementFound.type, val)
                      : null,
                  disabledHint: Text(
                    elementFound.alias,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ),
              );
            }

            return TextFormField(
              key: ValueKey(elementFound.name),
              controller: _controllers[elementFound.name],
              readOnly: attribute.display.enumerator == "read",
              decoration: InputDecoration(
                labelText: elementFound.alias,
                labelStyle: const TextStyle(color: Colors.black),
                errorText: validationErrors[elementFound.name],
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: elementFound.editable
                  ? (val) => formValues[elementFound.name] =
                      EsriTypeConversion.convert(elementFound.type, val)
                  : null,
              enabled: elementFound.editable,
            );
          }

          return const SizedBox();
        }),
        // ...widget.schema.map((field) {
        //   if (field.codedValues != null) {
        //     final asbrdMetadata = schema.getByName(field.name);

        //     final seenCodes = <dynamic>{};
        //     final uniqueCodedValues = field.codedValues!
        //         .where((item) =>
        //             item['code'] != null && seenCodes.add(item['code']))
        //         .toList();
        //     final selectedValue = formValues[field.name];
        //     final valueExists =
        //         uniqueCodedValues.any((item) => item['code'] == selectedValue);
        //     final effectiveValue =
        //         valueExists ? selectedValue : field.defaultValue;

        //     return AbsorbPointer(
        //       absorbing: !field.editable,
        //       child: DropdownButtonFormField(
        //         key: ValueKey(field.name),
        //         isExpanded: true,
        //         decoration: InputDecoration(
        //           labelText: field.alias,
        //           labelStyle: const TextStyle(color: Colors.black),
        //           errorText: validationErrors[field.name],
        //         ),
        //         value: effectiveValue,
        //         items: uniqueCodedValues
        //             .map((code) => DropdownMenuItem(
        //                   value: code['code'],
        //                   child: Text(
        //                     code['name'].toString(),
        //                     overflow: TextOverflow.ellipsis,
        //                     style: const TextStyle(color: Colors.black),
        //                   ),
        //                 ))
        //             .toList(),
        //         onChanged: field.editable
        //             ? (val) => formValues[field.name] =
        //                 EsriTypeConversion.convert(field.type, val)
        //             : null,
        //         disabledHint: Text(
        //           effectiveValue != null ? effectiveValue.toString() : '',
        //           style: const TextStyle(color: Colors.black45),
        //         ),
        //       ),
        //     );
        //   }
        //   return TextFormField(
        //     key: ValueKey(field.name),
        //     controller: _controllers[field.name],
        //     readOnly: !field.editable,
        //     decoration: InputDecoration(
        //       labelText: field.alias,
        //       labelStyle: const TextStyle(color: Colors.black),
        //       errorText: validationErrors[field.name],
        //     ),
        //     style: const TextStyle(color: Colors.black),
        //     onChanged: field.editable
        //         ? (val) => formValues[field.name] =
        //             EsriTypeConversion.convert(field.type, val)
        //         : null,
        //     enabled: field.editable,
        //   );
        // }),
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
            if (widget.selectedShapeType == ShapeType.point)
              OutlinedButton.icon(
                onPressed: () {
                  if (widget.onDwelling != null) {
                    widget.onDwelling!(widget.entranceGlobalId);
                  }
                },
                icon: const Icon(Icons.home_work, color: Colors.black),
                label: const Text('Manage Dwelling',
                    style: TextStyle(color: Colors.black)),
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

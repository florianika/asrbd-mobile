import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:flutter/material.dart';

class DynamicElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>)? onSave;

  final void Function()? onClose;

  const DynamicElementAttribute({
    required this.schema,
    this.initialData,
    this.onSave,
    this.onClose,
    super.key,
  });

  @override
  State<DynamicElementAttribute> createState() =>
      _DynamicElementAttributeFormState();
}

class _DynamicElementAttributeFormState extends State<DynamicElementAttribute> {
  final Map<String, dynamic> formValues = {};
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
      final value = data[field.name]?.toString() ?? '';
      if (_controllers.containsKey(field.name)) {
        _controllers[field.name]!.text = value;
      } else {
        _controllers[field.name] = TextEditingController(text: value);
      }
    }

    setState(() {}); // Trigger rebuild
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    if (widget.onSave != null) {
      widget.onSave!(formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.schema.map((field) {
          // final value = formValues[field.name] ?? field.defaultValue;
          if (field.codedValues != null) {
            // Deduplicate by 'code' and ensure all 'code' values are not null
            final seenCodes = <dynamic>{};
            final uniqueCodedValues = field.codedValues!
                .where((item) =>
                    item['code'] != null && seenCodes.add(item['code']))
                .toList();

            // Get current value
            final selectedValue = formValues[field.name];

            // Ensure the selected value is in the unique list
            final valueExists =
                uniqueCodedValues.any((item) => item['code'] == selectedValue);
            final effectiveValue = valueExists ? selectedValue : null;

            return DropdownButtonFormField(
              key: ValueKey(field.name),
              isExpanded: true,
              decoration: InputDecoration(
                labelText: field.alias,
                labelStyle: const TextStyle(color: Colors.black),
              ),
              value: effectiveValue,
              items: uniqueCodedValues
                  .map((code) => DropdownMenuItem(
                        value: code['code'],
                        child: Text(
                          code['name'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged:
                  field.editable ? (val) => formValues[field.name] = val : null,
              disabledHint: Text(
                effectiveValue != null ? effectiveValue.toString() : '',
                style: const TextStyle(color: Colors.black45),
              ),
            );
          }
          return TextFormField(
            key: ValueKey(field.name),
            controller: _controllers[field.name],
            decoration: InputDecoration(
              labelText: field.alias,
              labelStyle: const TextStyle(color: Colors.black),
            ),
            style: const TextStyle(color: Colors.black),
            onChanged:
                field.editable ? (val) => formValues[field.name] = val : null,
            enabled: field.editable,
          );
        }),
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

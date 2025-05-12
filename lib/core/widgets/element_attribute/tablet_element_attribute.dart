import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:flutter/material.dart';

class TabletElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;
  final Function save;

  const TabletElementAttribute({
    super.key,
    required this.schema,
    required this.onClose,
    required this.initialData,
    required this.save,
  });

  @override
  State<TabletElementAttribute> createState() =>
      _TabletElementAttributeViewState();
}

class _TabletElementAttributeViewState extends State<TabletElementAttribute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    textTheme: const TextTheme(
                      bodyMedium: TextStyle(color: Colors.black),
                    ),
                  ),
                  child: DynamicElementAttribute(
                    schema: widget.schema,
                    initialData: widget.initialData,
                    onSave: (formValues) {
                      widget.save(formValues);
                    },
                    onClose: widget.onClose,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class TabletElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType ;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;
  final Function save;

  const TabletElementAttribute({
    super.key,
    required this.schema,
    required this.selectedShapeType,
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
                    selectedShapeType:widget.selectedShapeType,
                    initialData: widget.initialData,
                    onSave: (formValues) {
                      widget.save(formValues);
                    },
                    onClose: widget.onClose,
                    onDwelling: _openNewDwellingForm, // 👈 NEW FORM
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openNewDwellingForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Dwelling Form', style: TextStyle(color: Colors.black)),
          ),
          body: Padding(
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
                schema: _getDwellingSchema(),
                 selectedShapeType:widget.selectedShapeType,
                initialData: {}, 
                onSave: (dwellingData) {
                  Navigator.of(context).pop(); 
                  debugPrint('Saved dwelling: $dwellingData');
                },
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<FieldSchema> _getDwellingSchema() {
    // Replace this with real dwelling schema
    return [
      FieldSchema(
        name: 'DwlCode',
        alias: 'Dwelling Code',
        type: 'esriFieldTypeString',
        editable: true,
        nullable: false,
      ),
      FieldSchema(
        name: 'DwlType',
        alias: 'Dwelling Type',
        type: 'esriFieldTypeInteger',
        editable: true,
        nullable: true,
        codedValues: [
          {'code': 1, 'name': 'Apartment'},
          {'code': 2, 'name': 'House'},
        ],
      ),
      FieldSchema(
        name: 'NumRooms',
        alias: 'Number of Rooms',
        type: 'esriFieldTypeInteger',
        editable: true,
        nullable: true,
      ),
    ];
  }
}

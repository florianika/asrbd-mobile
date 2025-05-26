import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:flutter/material.dart';

class TabletElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;
  final Function save;
  final void Function()? onOpenDwelling;

  const TabletElementAttribute({
    super.key,
    required this.schema,
    required this.selectedShapeType,
    required this.onClose,
    required this.initialData,
    required this.save,
    this.onOpenDwelling,
  });

  @override
  State<TabletElementAttribute> createState() =>
      _TabletElementAttributeViewState();
}

class _TabletElementAttributeViewState extends State<TabletElementAttribute> {
  final GlobalKey<DynamicElementAttributeState> _dynamicFormKey = GlobalKey<DynamicElementAttributeState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
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
                          key: _dynamicFormKey,
                          schema: widget.schema,
                          selectedShapeType: widget.selectedShapeType,
                          initialData: widget.initialData,
                          onSave: (formValues) {
                            widget.save(formValues);
                          },
                          onClose: widget.onClose,
                          onDwelling: _openNewDwellingForm,
                          showButtons: false, // Hide buttons in child widget
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fixed bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: widget.onClose,
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
                    onPressed: () => _openNewDwellingForm(null),
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
                  onPressed: () {
                    // Call the save method from the child widget
                    _dynamicFormKey.currentState?.handleSave();
                  },
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
          ),
        ],
      ),
    );
  }

  void _openNewDwellingForm(String? entranceGlobalId) {
    if (widget.onOpenDwelling != null) {
      widget.onOpenDwelling!();
    }
  }
}
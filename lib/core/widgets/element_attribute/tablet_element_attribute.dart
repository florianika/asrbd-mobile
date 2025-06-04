import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/validation/validaton_result.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/event_button_attribute.dart';
import 'package:flutter/material.dart';

class TabletElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;
  final Function save;
  final void Function()? onOpenDwelling;
  final bool readOnly;

  const TabletElementAttribute(
      {super.key,
      required this.schema,
      required this.selectedShapeType,
      required this.onClose,
      required this.initialData,
      required this.save,
      this.onOpenDwelling,
      this.readOnly = false});

  @override
  State<TabletElementAttribute> createState() =>
      _TabletElementAttributeViewState();
}

class _TabletElementAttributeViewState extends State<TabletElementAttribute> {
  final GlobalKey<DynamicElementAttributeState> _dynamicFormKey =
      GlobalKey<DynamicElementAttributeState>();

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
                          validationResults: [
                            ValidationResult(
                              name: 'BldCentroidStatus',
                              message:
                                  'This field has an error that needs attention',
                              level: ValidationLevel.error,
                            ),
                            ValidationResult(
                              name: 'BldReview',
                              message: 'This field has a warning',
                              level: ValidationLevel.warning,
                            ),
                          ],
                          onClose: widget.onClose,
                          onDwelling: _openNewDwellingForm,
                          showButtons: false,
                          readOnly: widget.readOnly,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!widget.readOnly)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: EventButtonAttribute(
                onSave: () => _dynamicFormKey.currentState?.handleSave(),
                onClose: () => widget.onClose(),
                openDwelling: () => _openNewDwellingForm(null),
                selectedShapeType: widget.selectedShapeType,
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

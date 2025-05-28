import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/event_button_attribute.dart';
import 'package:flutter/material.dart';

void mobileElementAttribute(
  BuildContext context,
  List<FieldSchema> schema,
  ShapeType shapeType,
  Map<String, dynamic> initialData,
  Function onSave,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Icon(Icons.drag_handle, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: const InputDecorationTheme(
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        textTheme: const TextTheme(
                          bodyMedium: TextStyle(color: Colors.black),
                        ),
                      ),
                      child: DynamicElementAttribute(
                        schema: schema,
                        selectedShapeType: shapeType,
                        initialData: initialData,
                        onSave: (formValues) {
                          onSave(formValues);
                        },
                      ),
                    ),
                    EventButtonAttribute(
                      onSave: onSave,
                      onClose: null,
                      openDwelling: () => (),
                      selectedShapeType: shapeType,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

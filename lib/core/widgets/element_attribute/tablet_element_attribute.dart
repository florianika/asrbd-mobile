import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:asrdb/core/widgets/element_attribute/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:asrdb/features/home/data/dwelling_repository.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    onDwelling: _openNewDwellingForm,
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
 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => DwellingCubit(
        DwellingUseCases(
          DwellingRepository(
            DwellingService(
              DwellingApi(),
            ),
          ),
        ),
      ),
      child: DwellingForm(selectedShapeType: ShapeType.point),
    ),
  ),
);

}
}

import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/validation/process_output_log_response_extension.dart';
import 'package:asrdb/core/models/validation/validaton_result.dart';
import 'package:asrdb/core/widgets/element_attribute/dynamic_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/event_button_attribute.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabletElementAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final bool entranceOutsideVisibleArea;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;
  final Function save;
  final bool readOnly;
  final Function startReviewing;
  final Function finishReviewing;

  const TabletElementAttribute(
      {super.key,
      required this.schema,
      required this.selectedShapeType,
      required this.entranceOutsideVisibleArea,
      required this.onClose,
      required this.initialData,
      required this.save,
      required this.startReviewing,
      this.readOnly = false,
      required this.finishReviewing});

  @override
  State<TabletElementAttribute> createState() =>
      _TabletElementAttributeViewState();
}

class _TabletElementAttributeViewState extends State<TabletElementAttribute> {
  final GlobalKey<DynamicElementAttributeState> _dynamicFormKey =
      GlobalKey<DynamicElementAttributeState>();

  List<ValidationResult>? validationResult;

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
                        child: BlocConsumer<OutputLogsCubit, OutputLogsState>(
                          listener: (context, state) {
                            if (state is OutputLogsError) {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                MaterialBanner(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red.shade100,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentMaterialBanner();
                                      },
                                      child: const Text('Dismiss'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            List<ValidationResult> validationResult = [];

                            if (state is OutputLogs) {
                              validationResult = state.validationResult
                                  .toValidationResults(useAlbanianMessage: true)
                                  .where((x) =>
                                      x.entityType ==
                                      (widget.selectedShapeType ==
                                              ShapeType.polygon
                                          ? EntityType.building
                                          : widget.selectedShapeType ==
                                                  ShapeType.point
                                              ? EntityType.entrance
                                              : EntityType.dwelling))
                                  .toList();
                            }

                            // if (state is OutputLogsError) {
                            //   return MessageBox.error(
                            //     title: 'Error output logs',
                            //     message: state.message,
                            //     onClose: () => print('Static message closed'),
                            //   );
                            // }

                            return DynamicElementAttribute(
                              key: _dynamicFormKey,
                              schema: widget.schema,
                              selectedShapeType: widget.selectedShapeType,
                              entranceOutsideVisibleArea:
                                  widget.entranceOutsideVisibleArea,
                              initialData: widget.initialData,
                              onSave: (formValues) => widget.save(formValues),
                              validationResults: validationResult,
                              onClose: widget.onClose,
                              showButtons: false,
                              readOnly: widget.readOnly,
                            );
                          },
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
                globalId: widget.initialData['GlobalID'],
                startReviewingBuilding: widget.startReviewing,
                finishReviewingBuilding: widget.finishReviewing,
                openDwelling: () => {
                  context
                      .read<DwellingCubit>()
                      .getDwellings(widget.initialData['GlobalID']),
                },
                selectedShapeType: widget.selectedShapeType,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:asrdb/core/enums/form_context.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute_shimmer.dart';
import 'package:asrdb/core/widgets/side_container.dart';
import 'package:flutter/material.dart';

class ViewAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final bool entranceOutsideVisibleArea;
  final VoidCallback onClose;
  final bool isLoading;
  final Map<String, dynamic> initialData;
  final Future<void> Function(Map<String, dynamic>) save;
  final Function startReviewing;
  final Function finishReviewing;
  final FormContext formContext;
  final void Function()? onEdit;
  final void Function()? onCancel;

  const ViewAttribute({
    super.key,
    required this.schema,
    required this.selectedShapeType,
    required this.entranceOutsideVisibleArea,
    required this.onClose,
    required this.initialData,
    required this.save,
    required this.isLoading,
    required this.startReviewing,
    required this.finishReviewing,
    this.formContext = FormContext.view,
    this.onEdit,
    this.onCancel,
  });

  @override
  State<ViewAttribute> createState() => _ViewAttributeState();
}

class _ViewAttributeState extends State<ViewAttribute> {
  String? _lastGlobalId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _lastGlobalId ??= widget.initialData['GlobalID']?.toString();
  }

  @override
  void didUpdateWidget(covariant ViewAttribute oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newGlobalId = widget.initialData['GlobalID']?.toString();
    if (_lastGlobalId != null &&
        newGlobalId != null &&
        newGlobalId != _lastGlobalId) {}

    _lastGlobalId = newGlobalId;
  }

  @override
  Widget build(BuildContext context) {
    return SideContainer(
      child: widget.isLoading
          ? const ViewAttributeShimmer()
          : TabletElementAttribute(
              schema: widget.schema,
              selectedShapeType: widget.selectedShapeType,
              entranceOutsideVisibleArea: widget.entranceOutsideVisibleArea,
              initialData: widget.initialData,
              save: widget.save,
              startReviewing: widget.startReviewing,
              onClose: widget.onClose,
              finishReviewing: widget.finishReviewing,
              formContext: widget.formContext,
              onEdit: widget.onEdit,
              onCancel: widget.onCancel,
            ),
    );
  }
}

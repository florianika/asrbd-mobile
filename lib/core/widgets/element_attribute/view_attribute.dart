import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/mobile_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute_shimmer.dart';
import 'package:asrdb/core/widgets/side_container.dart';
import 'package:flutter/material.dart';

class ViewAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final VoidCallback onClose;
  final bool isLoading;
  final Map<String, dynamic> initialData;
  final Function save;
  final Function startReviewing;
  final Function finishReviewing;

  const ViewAttribute({
    super.key,
    required this.schema,
    required this.selectedShapeType,
    required this.onClose,
    required this.initialData,
    required this.save,
    required this.isLoading,
    required this.startReviewing,
    required this.finishReviewing,
  });

  @override
  State<ViewAttribute> createState() => _ViewAttributeState();
}

class _ViewAttributeState extends State<ViewAttribute> {
  bool _isMobileSheetVisible = false;
  bool? _isMobile; // Nullable so we know if it's initialized
  String? _lastGlobalId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isMobileView =
        MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint;

    if (_isMobile == null) {
      setState(() {
        _isMobile = isMobileView;
      });

      if (isMobileView) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showMobileElementAttribute();
        });
      }
    }

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

  void _showMobileElementAttribute() {
    if (!mounted || _isMobileSheetVisible) return;

    _isMobileSheetVisible = true;

    mobileElementAttribute(
      context,
      widget.schema,
      widget.selectedShapeType,
      widget.initialData,
      widget.save,
    );

    // Automatically call onClose after modal closes
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isMobileSheetVisible = false;
        });
        widget.onClose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isMobile == null) {
      return const SizedBox.shrink();
    }

    if (_isMobile!) {
      return const SizedBox.shrink();
    }

    return SideContainer(
      child: widget.isLoading
          ? const ViewAttributeShimmer()
          : TabletElementAttribute(
              schema: widget.schema,
              selectedShapeType: widget.selectedShapeType,
              initialData: widget.initialData,
              save: widget.save,
              startReviewing: widget.startReviewing,
              onClose: widget.onClose,
              finishReviewing: widget.finishReviewing,
            ),
    );
  }
}

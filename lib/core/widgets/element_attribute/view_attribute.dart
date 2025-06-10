import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/dwelling/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/mobile_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute_shimmer.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAttribute extends StatefulWidget {
  final List<FieldSchema> schema;
  final ShapeType selectedShapeType;
  final VoidCallback onClose;
  final bool showDwellings;
  final bool isLoading;
  final Map<String, dynamic> initialData;
  final Function save;
  final void Function()? onOpenDwelling;

  const ViewAttribute({
    super.key,
    required this.schema,
    required this.selectedShapeType,
    required this.onClose,
    required this.initialData,
    required this.save,
    this.onOpenDwelling,
    required this.isLoading,
    required this.showDwellings,
  });

  @override
  State<ViewAttribute> createState() => _ViewAttributeState();
}

class _ViewAttributeState extends State<ViewAttribute> {
  bool _isDwellingVisible = false;
  double _sidePanelFractionDefualt = 0.4;
  final double _defaultDwellingWidthFraction = 0.8;
  bool _showDwellings = false;

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
        newGlobalId != _lastGlobalId) {
      setState(() {
        _isDwellingVisible = false;
        _sidePanelFractionDefualt = 0.4;
      });
    }

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
      return const SizedBox.shrink(); // Or a loader if needed
    }

    if (_isMobile!) {
      return const SizedBox.shrink(); // Don't render anything in mobile
    }

    return Row(children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          setState(() {
            _sidePanelFractionDefualt -=
                details.delta.dx / MediaQuery.of(context).size.width;
            _sidePanelFractionDefualt =
                _sidePanelFractionDefualt.clamp(0.4, 0.9);
          });
        },
        onDoubleTap: () {
          setState(() {
            _sidePanelFractionDefualt = 0.4;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: Container(
            width: 8,
            color: Colors.grey.shade300,
            child: Center(
              child: Container(
                width: 10,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * _sidePanelFractionDefualt,
        child: widget.isLoading
            ? const ViewAttributeShimmer()
            : _showDwellings
                ? DwellingForm(
                    selectedShapeType: ShapeType.point,
                    entranceGlobalId:
                        widget.initialData['GlobalID']?.toString(),
                    onBack: () {
                      setState(() {
                        _showDwellings = false;
                      });
                    },
                  )
                : TabletElementAttribute(
                    schema: widget.schema,
                    selectedShapeType: widget.selectedShapeType,
                    initialData: widget.initialData,
                    save: widget.save,
                    onClose: widget.onClose,
                    onOpenDwelling: () {
                      setState(() {
                        _showDwellings = true;
                        _sidePanelFractionDefualt =
                            _defaultDwellingWidthFraction;
                      });
                    },
                  ),
      )
    ]);
  }
}

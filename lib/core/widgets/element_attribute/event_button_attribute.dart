import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class EventButtonAttribute extends StatelessWidget {
  final Function onSave;
  final Function? onClose;
  final ShapeType selectedShapeType;
  final Function openDwelling;
  final Function? onValidateData;
  final Function? onViewValidationResult;

  const EventButtonAttribute({
    super.key,
    required this.onSave,
    required this.onClose,
    required this.selectedShapeType,
    required this.openDwelling,
    this.onValidateData,
    this.onViewValidationResult,
  });

  void handleValidation() {}

  @override
  Widget build(BuildContext context) {
    const double buttonWidth = 90;
    const double buttonHeight = 40;

    void validateData() {
      context.read<AttributesCubit>().setShowLoading(true);
      final buildingCubit = context.read<BuildingCubit>();
      final validateCubit = context.read<OutputLogsCubit>();

      if (buildingCubit.globalId != null) {
        validateCubit.checkBuildings(buildingCubit.globalId!);
      }
      context.read<AttributesCubit>().setShowLoading(false);
    }

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onClose != null)
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: () => onClose!(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () => onSave(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Save'),
            ),
          ),
          SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 8.0,
            buttonSize: const Size(buttonWidth, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            overlayColor: Colors.grey,
            overlayOpacity: 0.2,
            children: [
              if (selectedShapeType == ShapeType.point)
                SpeedDialChild(
                  child: const Icon(Icons.home_work),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  label: 'Manage Dwellings',
                  labelBackgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  onTap: () => openDwelling(),
                ),
              SpeedDialChild(
                child: const Icon(Icons.check_circle),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                label: 'Validate Data',
                labelBackgroundColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
                onTap: () => validateData(),
              ),
              if (selectedShapeType == ShapeType.point ||
                  selectedShapeType == ShapeType.polygon)
                SpeedDialChild(
                  child: const Icon(Icons.edit),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  label: 'Edit Position',
                  labelBackgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  onTap: () => {},
                ),
            ],
          ),
        ],
      ),
    );
  }
}

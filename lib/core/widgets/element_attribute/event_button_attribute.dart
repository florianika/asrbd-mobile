import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/widgets/dialog_box.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
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
  final Function? startReviewingBuilding;
  final Function? finishReviewingBuilding;
  final String? globalId;

  const EventButtonAttribute({
    super.key,
    required this.onSave,
    required this.onClose,
    required this.selectedShapeType,
    required this.openDwelling,
    this.onValidateData,
    this.onViewValidationResult,
    this.globalId,
    this.startReviewingBuilding,
    this.finishReviewingBuilding,
  });

  void handleValidation() {}

  @override
  Widget build(BuildContext context) {
    const double buttonWidth = 90;
    const double buttonHeight = 40;
    final attributesCubit = context.read<AttributesCubit>();
    final attributes = attributesCubit.state is Attributes
        ? (attributesCubit.state as Attributes).initialData
        : {};

    final bldReview = attributes['BldReview'];
    final bldQuality = attributes['BldQuality'];

    Future<void> validateData() async {
      var loadingCubit = context.read<LoadingCubit>();

      loadingCubit.show();
      final buildingCubit = context.read<AttributesCubit>();
      final validateCubit = context.read<OutputLogsCubit>();

      try {
        if (buildingCubit.currentBuildingGlobalId != null) {
          await validateCubit
              .checkBuildings(buildingCubit.currentBuildingGlobalId!);
        }
      } finally {
        loadingCubit.hide();
      }
    }

    Future<void> startReviewing() async {
      // if BldReview == 7 update it to 4 using esri
      final confirmed = await showConfirmationDialog(
        context: context,
        title: 'Start Reviewing',
        content: 'Are you sure you want to start reviewing this building?',
      );

      if (confirmed && startReviewingBuilding != null) {
        startReviewingBuilding!(globalId);
      }
    }

    Future<void> finishReviewing() async {
      // if BldQuality == 9 show message 'You cant proceed without first validating the building
      // else {
      // show a modal to add a comment and if bldQuality = 1 and no comments added set BldReview = 2 else BldReview = 3
      //}
      final buildingCubit = context.read<AttributesCubit>();
      final confirmed = await showConfirmationDialog(
        context: context,
        title: 'Finish Reviewing',
        content: 'Are you sure you want to finish reviewing this building?',
      );

      if (confirmed && finishReviewingBuilding != null) {
        finishReviewingBuilding!(buildingCubit.currentBuildingGlobalId);
      }
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
              if (bldQuality == 9)
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
              if (selectedShapeType == ShapeType.polygon &&
                  (bldReview == 6 || (bldReview == 5)))
                SpeedDialChild(
                  child: const Icon(Icons.start),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  label: 'Start Reviewing',
                  labelBackgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  onTap: () => startReviewing(),
                ),
              if (selectedShapeType == ShapeType.polygon && bldReview == 4)
                SpeedDialChild(
                  child: const Icon(Icons.stop),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  label: 'Finish Review',
                  labelBackgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  onTap: () => finishReviewing(),
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

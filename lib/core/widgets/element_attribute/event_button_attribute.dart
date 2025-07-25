import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/core/models/field_work_status.dart';
import 'package:asrdb/core/models/validation/process_output_log_response_extension.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/widgets/dialog_box.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class EventButtonAttribute extends StatelessWidget {
  final Future<void> Function(Map<String, dynamic>) onSave;
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
      final loadingCubit = context.read<LoadingCubit>();
      final validateCubit = context.read<OutputLogsCubit>();
      final shapeType = selectedShapeType;
      final currentContext = context;

      final buildingGlobalId = attributesCubit.currentBuildingGlobalId;
      final entranceGlobalId = attributesCubit.currentEntranceGlobalId;
      final dwellingObjectId = attributesCubit.currentDwellingObjectId;

      loadingCubit.show();
      bool validationSuccessful = false;

      try {
        if (buildingGlobalId != null) {
          await validateCubit.checkBuildings(buildingGlobalId);
          if (validateCubit.state is OutputLogs) {
            final outputLogs = validateCubit.state as OutputLogs;
            final validationResults =
                outputLogs.validationResult.toValidationResults();

            validationSuccessful = validationResults.isEmpty ||
                !validationResults.any(
                    (result) => result.level == ValidationLevel.error);
          }
        }
      } finally {
        loadingCubit.hide();

        if (buildingGlobalId != null && shapeType == ShapeType.polygon) {
          await attributesCubit.showBuildingAttributes(buildingGlobalId);
        } else if (entranceGlobalId != null && shapeType == ShapeType.point) {
          await attributesCubit.showEntranceAttributes(
              entranceGlobalId, buildingGlobalId);
        } else if (dwellingObjectId != null &&
            shapeType == ShapeType.noShape) {
          await attributesCubit.showDwellingAttributes(dwellingObjectId);
        }

        NotifierService.showMessage(
          currentContext,
          messageKey: validationSuccessful
              ? Keys.successGeneral
              : Keys.finishValidateWarning,
          type: validationSuccessful
              ? MessageType.success
              : MessageType.warning,
        );
      }
    }

    Future<void> startReviewing() async {
      final confirmed = await showConfirmationDialog(
        context: context,
        title: AppLocalizations.of(context).translate(Keys.startReviewingTitle),
        content:
            AppLocalizations.of(context).translate(Keys.startReviewingContent),
      );

      if (confirmed && startReviewingBuilding != null) {
        startReviewingBuilding!(globalId);
      }
    }

    Future<void> finishReviewing() async {
      final confirmed = await showConfirmationDialog(
        context: context,
        title: AppLocalizations.of(context).translate(Keys.finishReviewingTitle),
        content:
            AppLocalizations.of(context).translate(Keys.finishReviewingContent),
      );

      if (confirmed && finishReviewingBuilding != null) {
        finishReviewingBuilding!(attributesCubit.currentBuildingGlobalId);
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  AppLocalizations.of(context).translate(Keys.close),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () async {
                await onSave({});
                await validateData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(AppLocalizations.of(context).translate(Keys.save)),
            ),
          ),
          BlocBuilder<FieldWorkCubit, FieldWorkStatus>(
            builder: (context, fieldWorkStatus) {
              return SpeedDial(
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
                      label: AppLocalizations.of(context)
                          .translate(Keys.manageDwellings),
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
                      label: AppLocalizations.of(context)
                          .translate(Keys.validateData),
                      labelBackgroundColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      onTap: () => validateData(),
                    ),
                  if (selectedShapeType == ShapeType.polygon &&
                      (bldReview == DefaultData.reviewRequired ||
                          bldReview == DefaultData.reviewReopened) &&
                      fieldWorkStatus.isFieldworkTime)
                    SpeedDialChild(
                      child: const Icon(Icons.start),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      label: AppLocalizations.of(context)
                          .translate(Keys.startReviewing),
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
                      label: AppLocalizations.of(context)
                          .translate(Keys.finishReviewing),
                      labelBackgroundColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      onTap: () => finishReviewing(),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

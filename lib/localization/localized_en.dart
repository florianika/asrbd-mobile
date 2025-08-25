import 'package:asrdb/localization/keys.dart';

class LocalizedEn {
  static final Map<String, String> localizedStrings = {
    Keys.save: 'Save',
    Keys.close: 'Close',
    Keys.login: 'Login',
    Keys.cancel: 'Cancel',
    Keys.proceed: 'Proceed',
    Keys.enterMail: 'Enter email',
    Keys.mailPlaceholder: 'Email',
    Keys.passwordPlaceholder: 'Password',
    Keys.enterPassword: 'Enter password',
    Keys.outsideMunicipality:
        'Please verify the coordinates, as they appear to be outside the municipality you are authorized for.',
    Keys.overlapingBuildings:
        'The newly added building overlaps with an existing building.',
    Keys.finishReviewWarning:
        'You can\'t proceed without first validating the building.',
    Keys.dwellingUpdated:
        'The dwelling information was successfully updated and saved.',
    Keys.dwellingCouldNotUpdated:
        'Dwelling could not be updated. Check your input and try again.',
    Keys.dwellingAdded:
        'The dwelling information was successfully added and saved.',
    Keys.dwellingCouldNotAdd:
        'Dwelling could not be added. Check your input and try again.',
    Keys.basemapTerrain: 'Terrein',
    Keys.basemapSatellite: 'Satellite',
    Keys.download: 'Download',
    Keys.startReviewingTitle: 'Start Reviewing',
    Keys.startReviewingContent:
        'Are you sure you want to start reviewing this building?',
    Keys.finishReviewingTitle: 'Finish Reviewing',
    Keys.finishReviewingContent:
        'Are you sure you want to finish reviewing this building?',
    Keys.manageDwellings: 'Manage Dwellings',
    Keys.validateData: 'Validate Data',
    Keys.startReviewing: 'Start Reviewing',
    Keys.finishReviewing: 'Finish Reviewing',
    Keys.legend: 'Legend',
    Keys.legendBuildings: 'Buildings',
    Keys.legendEntrances: 'Entrances',
    Keys.confirmationTitle: 'Confirmation',
    Keys.confirmationContent: 'Are you sure you want to proceed?',
    Keys.confirmationCancel: 'Cancel',
    Keys.confirmationConfirm: 'Confirm',
    Keys.successGeneral: "All changes were applied successfully.",
    Keys.finishValidateWarning:
        "Please verify the structural components of the building.",
        Keys.finishValidateSuccess:
        "Validation completed successfully. The building’s component elements do not require further checks.",
    Keys.invalidShape: "The drawn shape is not valid. Please try again.",
    Keys.successAddBuilding: "Building was successfully added.",
    Keys.successUpdateBuilding: "Building was successfully updated.",
    Keys.successAddEntrance: "Entrance was successfully added.",
    Keys.successUpdateEntrance: "Entrance was successfully updated.",
    Keys.successAddDwelling: "Dwelling was successfully added.",
    Keys.successUpdateDwelling: "Dwelling was successfully updated.",
    Keys.startValidationSuccess: "Validation started successfully",
    Keys.startValidationWarning: "Validation could not be started.",
    Keys.finishReviewingSuccess: 'Finish reviewing finished successfully',
    Keys.intersectionDetected: "Intersection detected",
    Keys.intersectionMessage:
        "Selected building has an intersection with another one. Do you want to continue and save it?",
  };
}

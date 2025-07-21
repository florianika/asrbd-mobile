import 'package:asrdb/localization/keys.dart';

class LocalizedEn {
  static final Map<String, String> localizedStrings = {
    Keys.login: 'Login',
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
        'Dwelling could not be added. Check your input and try again.'
  };
}

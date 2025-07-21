import 'package:asrdb/localization/keys.dart';

class LocalizedAl {
  static final Map<String, String> localizedStrings = {
    Keys.login: 'Hyr',
    Keys.enterMail: 'Vendosni email',
    Keys.mailPlaceholder: 'Email',
    Keys.passwordPlaceholder: 'Fjalëkalimi',
    Keys.enterPassword: 'Vendosni fjalëkalimin',
    Keys.outsideMunicipality:
        'Verifikoni koordinatat, pasi rezultojnë të jenë jashtë bashkisë për të cilën jeni të autorizuar.',
    Keys.overlapingBuildings:
        'Ndërtesa e hedhur ka mbivendosje me një ndërtesë ekzistuese.',
    Keys.finishReviewWarning:
        'Nuk mund të vazhdoni pa kryer fillimisht verifikimin e ndërtesës.',
    Keys.dwellingUpdated:
        'Të dhënat e njësisë së banimit u shtuan dhe u ruajtën me sukses.',
    Keys.dwellingCouldNotUpdated:
        'Nuk u arrit të shtohet njësia e banimit. Ju lutemi, provoni përsëri'
  };
}

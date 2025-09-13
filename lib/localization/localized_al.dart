import 'package:asrdb/localization/keys.dart';

class LocalizedAl {
  static final Map<String, String> localizedStrings = {
    Keys.save: 'Ruaj',
    Keys.close: 'Mbyll',
    Keys.login: 'Hyr',
    Keys.cancel: 'Anullo',
    Keys.proceed: 'Vijo',
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
        'Nuk u arrit të shtohet njësia e banimit. Ju lutemi, provoni përsëri',
    Keys.basemapTerrain: 'Terren',
    Keys.basemapSatellite: 'Satelit',
    Keys.download: 'Shkarko',
    Keys.startReviewingTitle: 'Fillo Rishikimin',
    Keys.startReviewingContent:
        'Jeni i sigurt që doni të filloni rishikimin e kësaj ndërtese?',
    Keys.finishReviewingTitle: 'Perfundo Rishikimin',
    Keys.finishReviewingContent:
        'Jeni i sigurt që doni të përfundoni rishikimin e kësaj ndërtese?',
    Keys.manageDwellings: 'Menaxho Banesat',
    Keys.validateData: 'Valido të Dhënat',
    Keys.validateDataUntestedData:
        'Validimi nuk mund te kryhet. Te dhenat jane te pa testuara (BldQuality != 9).',
    Keys.startReviewing: 'Fillo Rishikimin',
    Keys.finishReviewing: 'Përfundo Rishikimin',
    Keys.finishReviewingSuccess: 'Mbyllja e rishikimit perfundoi me sukses',
    Keys.legend: 'Legjenda',
    Keys.legendBuildings: 'Ndertesat',
    Keys.legendEntrances: 'Hyrjet',
    Keys.confirmationTitle: 'Konfirmim',
    Keys.confirmationContent: 'Jeni i sigurt që doni të vazhdoni?',
    Keys.confirmationCancel: 'Anulo',
    Keys.confirmationConfirm: 'Konfirmo',
    Keys.successGeneral: "Të gjitha ndryshimet u aplikuan me sukses.",
    Keys.finishValidateWarning:
        "Ju lutem, verifikoni elementët përbërës të ndërtesës.",
    Keys.finishValidateSuccess:
        "Validimi perfundoi me sukses. Komponentet perberes te nderteses nuk kane nevoje per kontroll.",
    Keys.invalidShape:
        "Forma e hedhur nuk është e vlefshme. Ju lutemi, provoni përsëri.",
    Keys.successAddBuilding: "Ndertesa u shtua me sukses.",
    Keys.successUpdateBuilding: "Ndertesa u përditësua me sukses.",
    Keys.successAddEntrance: "Hyrja u shtua me sukses.",
    Keys.successUpdateEntrance: "Hyrja u përditësua me sukses.",
    Keys.successAddDwelling: "Apartamenti u shtua me sukses.",
    Keys.successUpdateDwelling: "Apartamenti u përditësua me sukses.",
    Keys.startValidationSuccess: "Nisja e validimit u krye me sukses",
    Keys.startValidationWarning: "Nisja e validimit nuk u krye.",
    Keys.intersectionDetected: "Mbivendosje ndertesash",
    Keys.intersectionMessage:
        "Ndertesa e zgjedhur ka mbivendosje me nje ndertese tjeter. Doni te vijoni me ruajtjen?",
    Keys.fieldWorkNotOpened: "Puna ne terrent nuk eshte nisur.",
    Keys.blReviewWarning :"Per ndertesen e zgjedhur nuk kerkohet rishikim ose ka nje rishikim te rihapur (BldReview != 6 && BldReview!=5).",
    Keys.blReviewNoPending : "Ndertesa e zgjedhur nuk ka statusin e rishikimit ne pritje. (BldReview = 4)",
    // Settings page translations
    Keys.settings: 'Cilësimet',
    Keys.dataManagement: 'Menaxhimi i të Dhënave',
    Keys.updateAndManageData: 'Përditëso dhe menaxho të dhënat e aplikacionit',
    Keys.updateJsonAttributes: 'Përditëso Atributet JSON',
    Keys.updateJsonAttributesDesc: 'Shkarko dhe përditëso skedarët e atributeve të ndërtesave, hyrjeve dhe banesave',
    Keys.updateSchemaFiles: 'Përditëso Skedarët e Skemës',
    Keys.updateSchemaFilesDesc: 'Shkarko dhe përditëso skedarët e përkufizimit të skemës',
    Keys.information: 'Informacioni',
    Keys.settingsInfoText: 'Përdorni këto opsione për të përditësuar skedarët tuaj lokalë me informacionin më të fundit nga serveri.',
    Keys.jsonAttributesUpdatedSuccess: 'Atributet JSON u përditësuan me sukses',
    Keys.jsonAttributesUpdateFailed: 'Dështoi përditësimi i atributeve JSON',
    Keys.schemaFilesUpdatedSuccess: 'Skedarët e skemës u përditësuan me sukses',
    Keys.schemaFilesUpdateFailed: 'Dështoi përditësimi i skedarëve të skemës',
    // Logout translations
    Keys.logout: 'Dil',
    Keys.logoutSubtitle: 'Dil nga llogaria juaj',
    Keys.logoutConfirmation: 'Konfirmo Daljen',
    Keys.logoutConfirmationMessage: 'Jeni i sigurt që doni të dilni?',
    Keys.logoutSuccess: 'U dol me sukses',
    Keys.logoutError: 'Dështoi dalja',
    
    // Side menu translations
    Keys.mobileApp: 'Mobile',
    Keys.viewMaps: 'Shiko Hartat',
    Keys.viewMapsSubtitle: 'Hartat e shkarkuara offline',
    Keys.settingsSubtitle: 'Konfigurimi i aplikacionit',
    Keys.profile: 'Profili',
    Keys.profileSubtitle: 'Detajet e llogarisë së përdoruesit',
    Keys.helpSupport: 'Ndihmë & Mbështetje',
    Keys.helpSupportSubtitle: 'Merrni ndihmë'
  };
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/localization/localized_al.dart';
import 'package:asrdb/localization/localized_en.dart';

//how to use this:

//AppLocalizations.of(context).translate(Strings.hello)
class AppLocalizations {
  static const Locale en = Locale('en', 'US');
  static const Locale al = Locale('sq', 'AL');

  static const List<Locale> supportedLocales = [
    en,
    al,
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  static Map<String, String> _localizedStrings = LocalizedEn.localizedStrings;

  final Locale locale;

  AppLocalizations(this.locale);

  // Updated 'of' method to handle nullable return type
  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations == null) {
      throw FlutterError('AppLocalizations not found in context');
    }
    return localizations;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static void setLocale(Locale locale) {
    if (locale.languageCode == 'en') {
      _localizedStrings = LocalizedEn.localizedStrings;
    } else if (locale.languageCode == 'sq') {
      _localizedStrings = LocalizedAl.localizedStrings;
    }
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Set the correct locale when loading.
    AppLocalizations.setLocale(locale);
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

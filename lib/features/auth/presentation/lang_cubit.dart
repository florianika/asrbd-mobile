import 'package:asrdb/core/config/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LangCubit extends Cubit<String> {
  LangCubit()
      : super(AppConfig.defaultLanguage); // Default language is English.

  void changeLanguage(String languageCode) {
    emit(languageCode); // Change language.
  }
}

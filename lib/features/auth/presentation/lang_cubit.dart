import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/constants/app_config.dart';

class LangCubit extends Cubit<String> {
  LangCubit()
      : super(AppConfig.defaultLanguage); // Default language is English.

  void changeLanguage(String languageCode) {
    emit(languageCode); // Change language.
  }
}

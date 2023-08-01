import 'package:flutter/material.dart';

import '../services/app_config.dart';
import '../services/shared_preference_helper.dart';

class AppLocalizationProvider extends ChangeNotifier {
  Locale? _locale;
  Locale get locale => _locale ?? const Locale('en');
  String language = '';

  Future<void> getLocalLocale() async {
    language = await SharedPreferencesHelper.getLocale();
    _locale = Locale(language);
    AppData.appLocale = language;
    notifyListeners();
  }

  Future<void> changeLocale(String lang) async {
    _locale = Locale(lang);
    await SharedPreferencesHelper.saveLocale(lang);
    AppData.appLocale = lang;
    notifyListeners();
  }
}

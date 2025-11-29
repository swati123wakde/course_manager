import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // Initialize and load saved language
  Future<void> initialize() async {
    final savedLanguage = _prefsService.getLanguage();
    _locale = Locale(savedLanguage);
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      await _prefsService.setLanguage(languageCode);
      notifyListeners();
    }
  }

  // Get supported locales
  List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('hi'),
  ];

  // Get language name
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      default:
        return 'English';
    }
  }
}
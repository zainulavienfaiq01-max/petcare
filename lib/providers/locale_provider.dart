import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/translations.dart';

/// Provider for multi-language support (17 languages).
/// English is set as the default language.
/// Uses SharedPreferences for persistence across app restarts.
class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get currentLanguageCode => _locale.languageCode;

  /// Initialize locale from saved preferences. English by default.
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    _locale = Locale(saved);
    notifyListeners();
  }

  /// Change the app language.
  Future<void> setLocale(String langCode) async {
    _locale = Locale(langCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, langCode);
  }

  /// Translate a key based on current locale.
  /// Falls back to English if key is not found in the target language.
  String translate(String key) {
    final langMap = AppTranslations.translations[_locale.languageCode];
    if (langMap != null && langMap.containsKey(key)) {
      return langMap[key]!;
    }
    
    // Fallback to English
    return AppTranslations.translations['en']?[key] ?? key;
  }
}

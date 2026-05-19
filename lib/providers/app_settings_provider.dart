// Holds all user-adjustable app settings.
// Language lives here alongside text scale — both are settings,
// so one provider keeps the widget tree simple.

import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';

class AppSettingsProvider extends ChangeNotifier {
  // ─── Text scale ──────────────────────────────────────────────────────────
  double _textScale = 1.0;

  double get textScale => _textScale;

  void setTextScale(double value) {
    if ((_textScale - value).abs() < 0.001) return;
    _textScale = value;
    notifyListeners();
  }

  // ─── Locale language ───────────────────────────────────────────────────────────────
  // Supported locale codes: 'nl' (default) | 'en'
  // This works with: app_localizations.dart, and the language toggle in settings_screen.dart. 
  // app_settings_provider.dart is the single source of truth for the current locale, so both the UI and the translation logic can read from it.
  String _locale = 'nl';

  String get locale => _locale;

  /// Convenience accessor so widgets can call appSettings.tr('key').
  AppLocalizations get l10n => AppLocalizations(_locale);

  void setLocale(String localeCode) {
    if (_locale == localeCode) return;
    _locale = localeCode;
    notifyListeners();
  }
}
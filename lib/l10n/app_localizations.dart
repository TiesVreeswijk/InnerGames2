// Add a new key to _en and _nl, then use it via context.tr('key').
// For strings with variables, use tr('key', {'placeholder': value}).

// This works with: app_localizations.dart, and the language toggle in settings_screen.dart. 
// app_settings_provider.dart is the single source of truth for the current locale, so both the UI and the translation logic can read from it.

class AppLocalizations {
  AppLocalizations(this.locale);

  final String locale; // 'en' or 'nl'

  // ─── Convenience accessor ────────────────────────────────────────────────
  String tr(String key, [Map<String, String>? args]) {
    final translations = locale == 'en' ? _en : _nl;
    String text = translations[key] ?? _en[key] ?? key;

    if (args != null) {
      args.forEach((placeholder, value) {
        text = text.replaceAll('{$placeholder}', value);
      });
    }

    return text;
  }

  // ─── English ─────────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    // App bar
    'settings_title': 'Settings',

    // Language section
    'section_language': 'Language',
    'lang_dutch': 'Dutch',
    'lang_english': 'English',

    // Appearance section
    'section_appearance': 'Appearance',
    'appearance_light': 'Light',
    'appearance_dark': 'Dark',
    'appearance_auto': 'Automatic (follows system settings)',

    // Toggles
    'toggle_sound': 'Sound',
    'toggle_haptic': 'Haptic',

    // Text size section
    'section_text_size': 'Text size',
    'text_size_current': 'Current app size: {size}%',
    'text_size_preview': 'Preview text size',
    'text_size_hint':
        'Release the slider to confirm and apply this text size across the whole app.',

    // Text size dialog
    'dialog_title': 'Apply text size?',
    'dialog_body': 'Use {size}% text size across the whole app?',
    'dialog_cancel': 'Cancel',
    'dialog_apply': 'Apply',
  };

  // ─── Dutch ────────────────────────────────────────────────────────────────
  static const Map<String, String> _nl = {
    // App bar
    'settings_title': 'Instellingen',

    // Language section
    'section_language': 'Taal',
    'lang_dutch': 'Nederlands',
    'lang_english': 'Engels',

    // Appearance section
    'section_appearance': 'Uiterlijk',
    'appearance_light': 'Licht',
    'appearance_dark': 'Donker',
    'appearance_auto': 'Automatisch (volgt systeeminstellingen)',

    // Toggles
    'toggle_sound': 'Geluid',
    'toggle_haptic': 'Haptisch',

    // Text size section
    'section_text_size': 'Tekstgrootte',
    'text_size_current': 'Huidige appgrootte: {size}%',
    'text_size_preview': 'Voorbeeld tekstgrootte',
    'text_size_hint':
        'Laat de schuifregelaar los om te bevestigen en deze tekstgrootte op de hele app toe te passen.',

    // Text size dialog
    'dialog_title': 'Tekstgrootte toepassen?',
    'dialog_body': 'Gebruik {size}% tekstgrootte in de hele app?',
    'dialog_cancel': 'Annuleer',
    'dialog_apply': 'Toepassen',
  };
}
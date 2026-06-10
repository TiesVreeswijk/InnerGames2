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
    'text_size_reset': 'Reset to 100%',
    'text_size_current': 'Current app size: {size}%',
    'text_size_preview': 'Preview text size',
    'text_size_hint':
        'Release the slider to confirm and apply this text size across the whole app.',

    // Text size dialog
    'dialog_title': 'Apply text size?',
    'dialog_body': 'Use {size}% text size across the whole app?',
    'dialog_cancel': 'Cancel',
    'dialog_apply': 'Apply',

    // Session flow
    'create_session_title': 'Create a new session',
    'join_session_title': 'Join a new session',
    'join_game_title': 'Join game',
    'join_pin_prompt': 'Enter the 4-digit PIN',
    'join_pin_loading': 'Searching for lobby...',
    'join_failed': 'Could not join: {error}',
    'enter_name': 'Enter your name',
    'name_too_short': 'The name must be at least 2 characters long',
    'name_hint': 'Name',

    // Move pawn screen
  "move_pawn_title": "Pawn",
  "move_pawn_description": "The story continues!\n\nMove the pawn forward 1.",
  "move_pawn_continue": "Continue"
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
    'text_size_reset': 'Reset naar 100%',
    'text_size_current': 'Huidige appgrootte: {size}%',
    'text_size_preview': 'Voorbeeld tekstgrootte',
    'text_size_hint':
        'Laat de schuifregelaar los om te bevestigen en deze tekstgrootte op de hele app toe te passen.',

    // Text size dialog
    'dialog_title': 'Tekstgrootte toepassen?',
    'dialog_body': 'Gebruik {size}% tekstgrootte in de hele app?',
    'dialog_cancel': 'Annuleer',
    'dialog_apply': 'Toepassen',

    // Session flow
    'create_session_title': 'Maak een nieuwe sessie aan',
    'join_session_title': 'Doe mee aan een nieuwe sessie',
    'join_game_title': 'Deelnemen aan spel',
    'join_pin_prompt': 'Voer de 4-cijferige PIN in',
    'join_pin_loading': 'Lobby zoeken...',
    'join_failed': 'Deelnemen mislukt: {error}',
    'enter_name': 'Vul je naam in',
    'name_too_short': 'De naam moet minimaal 2 tekens lang zijn',
    'name_hint': 'Naam',

    // Move pawn screen
  "move_pawn_title": "Pion",
  "move_pawn_description": "Het verhaal gaat verder!\n\nBeweeg de pion 1 stap vooruit.",
  "move_pawn_continue": "Verder"
  };
}
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

import '../theme/app_themeRyan.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/settings_controls.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'nl';
  String _selectedAppearance = 'auto';
  bool _soundEnabled = false;
  bool _hapticEnabled = false;
  double _textSize = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsSectionTitle(title: 'Taal'),
              const SizedBox(height: 16),
              SettingsInlineRadioGroup<String>(
                groupValue: _selectedLanguage,
                options: const [
                  SettingsOption(label: 'Nederlands', value: 'nl'),
                  SettingsOption(label: 'English', value: 'en'),
                ],
                onChanged: (value) {
                  setState(() => _selectedLanguage = value);
                },
              ),
              const SizedBox(height: 18),
              const SettingsDivider(),
              const SizedBox(height: 12),
              const SettingsSectionTitle(title: 'Uiterlijk'),
              const SizedBox(height: 10),
              SettingsVerticalRadioGroup<String>(
                groupValue: _selectedAppearance,
                options: const [
                  SettingsOption(label: 'Licht', value: 'light'),
                  SettingsOption(label: 'Donker', value: 'dark'),
                  SettingsOption(
                    label: 'Automatisch (volgt systeeminstellingen)',
                    value: 'auto',
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedAppearance = value);
                },
              ),
              const SizedBox(height: 8),
              const SettingsDivider(),
              const SizedBox(height: 12),
              SettingsToggleTile(
                label: 'Geluid',
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                },
              ),
              const SizedBox(height: 8),
              const SettingsDivider(),
              const SizedBox(height: 12),
              SettingsToggleTile(
                label: 'Haptisch',
                value: _hapticEnabled,
                onChanged: (value) {
                  setState(() => _hapticEnabled = value);
                },
              ),
              const SizedBox(height: 8),
              const SettingsDivider(),
              const SizedBox(height: 18),
              const SettingsSectionTitle(title: 'Tekstgrootte'),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.settingsUnselected,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.primaryMagenta,
                        inactiveTrackColor: AppTheme.settingsLightPurple,
                        thumbColor: AppTheme.primaryMagenta,
                        overlayColor: AppTheme.primaryMagenta.withValues(
                          alpha: 0.15,
                        ),
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14,
                        ),
                      ),
                      child: Slider(
                        value: _textSize,
                        min: 0.8,
                        max: 1.4,
                        divisions: 6,
                        label: '${(_textSize * 100).round()}%',
                        onChanged: (value) {
                          setState(() => _textSize = value);
                        },
                      ),
                    ),
                  ),
                  const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppTheme.primaryMagenta,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Voorbeeld tekstgrootte',
                style: TextStyle(
                  fontSize: 18 * _textSize,
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Image.asset(
                  'assets/images/innergames logo.png',
                  width: 110,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

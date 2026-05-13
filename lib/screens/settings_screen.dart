import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
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
  late double _previewTextScale;

  @override
  void initState() {
    super.initState();
    _previewTextScale = 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _previewTextScale = context.watch<AppSettingsProvider>().textScale;
  }

  Future<void> _confirmTextScale(double value) async {
    final appSettings = context.read<AppSettingsProvider>();
    final appliedValue = appSettings.textScale;

    if ((value - appliedValue).abs() < 0.001) {
      return;
    }

    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply text size?'),
        content: Text(
          'Use ${(value * 100).round()}% text size across the whole app?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apply'),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    if (shouldApply == true) {
      appSettings.setTextScale(value);
    } else {
      setState(() => _previewTextScale = appliedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appliedTextScale = context.watch<AppSettingsProvider>().textScale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
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
                    const SizedBox(height: 12),
                    Text(
                      'Huidige appgrootte: ${(appliedTextScale * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.settingsMuted,
                      ),
                    ),
                    const SizedBox(height: 18),
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
                              value: _previewTextScale,
                              min: 0.8,
                              max: 1.4,
                              onChanged: (value) {
                                setState(() => _previewTextScale = value);
                              },
                              onChangeEnd: _confirmTextScale,
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
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 88),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F3FA),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.settingsDivider),
                      ),
                      child: Center(
                        child: Text(
                          'Voorbeeld tekstgrootte',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18 * _previewTextScale),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Laat de schuifregelaar los om te bevestigen en deze tekstgrootte op de hele app toe te passen.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.settingsMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Center(
                child: Image.asset(
                  'assets/images/innergames logo.png',
                  width: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

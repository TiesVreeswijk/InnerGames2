// lib/screens/settings_screen.dart

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
  static const double _defaultTextScale = 1.0;
  String _selectedAppearance = 'auto';
  bool _soundEnabled = false;
  bool _hapticEnabled = false;
  late double _previewTextScale;

  @override
  void initState() {
    super.initState();
    _previewTextScale = _defaultTextScale;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _previewTextScale = context.watch<AppSettingsProvider>().textScale;
  }

  Future<void> _confirmTextScale(double value) async {
    final appSettings = context.read<AppSettingsProvider>();
    final appliedValue = appSettings.textScale;

    if ((value - appliedValue).abs() < 0.001) return;

    final l10n = appSettings.l10n;
    final sizeStr = (value * 100).round().toString();

    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tr('dialog_title')),
        content: Text(l10n.tr('dialog_body', {'size': sizeStr})),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.tr('dialog_cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.tr('dialog_apply')),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (shouldApply == true) {
      appSettings.setTextScale(value);
    } else {
      setState(() => _previewTextScale = appliedValue);
    }
  }

  void _resetTextScale() {
    final appSettings = context.read<AppSettingsProvider>();
    appSettings.setTextScale(_defaultTextScale);
    setState(() => _previewTextScale = _defaultTextScale);
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final l10n = appSettings.l10n;
    final appliedTextScale = appSettings.textScale;
    final selectedLanguage = appSettings.locale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.tr('settings_title'),
        showBackButton: Navigator.of(context).canPop(),
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
                    SettingsSectionTitle(title: l10n.tr('section_language')),
                    const SizedBox(height: 16),
                    SettingsInlineRadioGroup<String>(
                      groupValue: selectedLanguage,
                      options: [
                        SettingsOption(
                          label: l10n.tr('lang_dutch'),
                          value: 'nl',
                        ),
                        SettingsOption(
                          label: l10n.tr('lang_english'),
                          value: 'en',
                        ),
                      ],
                      onChanged: (value) {
                        // Switching language rebuilds the whole screen via
                        // notifyListeners() in AppSettingsProvider.
                        appSettings.setLocale(value);
                      },
                    ),
                    const SizedBox(height: 18),
                    const SettingsDivider(),
                    const SizedBox(height: 12),

                    // ── Appearance ───────────────────────────────────────
                    SettingsSectionTitle(title: l10n.tr('section_appearance')),
                    const SizedBox(height: 10),
                    SettingsVerticalRadioGroup<String>(
                      groupValue: _selectedAppearance,
                      options: [
                        SettingsOption(
                          label: l10n.tr('appearance_light'),
                          value: 'light',
                        ),
                        SettingsOption(
                          label: l10n.tr('appearance_dark'),
                          value: 'dark',
                        ),
                        SettingsOption(
                          label: l10n.tr('appearance_auto'),
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

                    // ── Sound ────────────────────────────────────────────
                    SettingsToggleTile(
                      label: l10n.tr('toggle_sound'),
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() => _soundEnabled = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    const SettingsDivider(),
                    const SizedBox(height: 12),

                    // ── Haptic ───────────────────────────────────────────
                    SettingsToggleTile(
                      label: l10n.tr('toggle_haptic'),
                      value: _hapticEnabled,
                      onChanged: (value) {
                        setState(() => _hapticEnabled = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    const SettingsDivider(),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: SettingsSectionTitle(
                            title: l10n.tr('section_text_size'),
                          ),
                        ),
                        TextButton(
                          onPressed: (appliedTextScale - _defaultTextScale)
                                      .abs() <
                                  0.001 &&
                              (_previewTextScale - _defaultTextScale).abs() <
                                  0.001
                              ? null
                              : _resetTextScale,
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryMagenta,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(l10n.tr('text_size_reset')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.tr('text_size_current', {
                        'size': (appliedTextScale * 100).round().toString(),
                      }),
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
                          l10n.tr('text_size_preview'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18 * _previewTextScale),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.tr('text_size_hint'),
                      style: const TextStyle(
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

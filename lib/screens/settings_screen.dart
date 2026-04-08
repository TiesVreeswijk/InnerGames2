import 'package:flutter/material.dart';

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
    const purple = Color(0xFF7A5AC8);
    const lightPurple = Color(0xFFE9DDFB);
    const divider = Color(0xFFD9D2E3);
    const titleBlue = Color(0xFF273583);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E3E3),
        elevation: 0,
        toolbarHeight: 86,
        titleSpacing: 16,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: titleBlue,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  side: const BorderSide(color: divider),
                  padding: const EdgeInsets.all(14),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF6A6670),
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle(title: 'Taal'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _RadioChoice(
                      label: 'Nederlands',
                      value: 'nl',
                      groupValue: _selectedLanguage,
                      activeColor: purple,
                      onChanged: (value) {
                        setState(() => _selectedLanguage = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _RadioChoice(
                      label: 'English',
                      value: 'en',
                      groupValue: _selectedLanguage,
                      activeColor: purple,
                      onChanged: (value) {
                        setState(() => _selectedLanguage = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: divider, thickness: 1),
              const SizedBox(height: 12),
              const _SectionTitle(title: 'Uiterlijk'),
              const SizedBox(height: 10),
              _AppearanceOption(
                label: 'licht',
                value: 'light',
                groupValue: _selectedAppearance,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => _selectedAppearance = value);
                },
              ),
              _AppearanceOption(
                label: 'Donker',
                value: 'dark',
                groupValue: _selectedAppearance,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => _selectedAppearance = value);
                },
              ),
              _AppearanceOption(
                label: 'Automatisch (volgt systeeminstellingen)',
                value: 'auto',
                groupValue: _selectedAppearance,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => _selectedAppearance = value);
                },
              ),
              const SizedBox(height: 8),
              const Divider(color: divider, thickness: 1),
              const SizedBox(height: 12),
              _ToggleRow(
                label: 'Geluid',
                value: _soundEnabled,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                },
              ),
              const SizedBox(height: 8),
              const Divider(color: divider, thickness: 1),
              const SizedBox(height: 12),
              _ToggleRow(
                label: 'Haptisch',
                value: _hapticEnabled,
                activeColor: purple,
                onChanged: (value) {
                  setState(() => _hapticEnabled = value);
                },
              ),
              const SizedBox(height: 8),
              const Divider(color: divider, thickness: 1),
              const SizedBox(height: 18),
              const _SectionTitle(title: 'Tekstgrootte'),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'A',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6A6670)),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: lightPurple,
                        inactiveTrackColor: lightPurple,
                        thumbColor: purple,
                        overlayColor: purple.withValues(alpha: 0.15),
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14,
                        ),
                      ),
                      child: Slider(
                        value: _textSize,
                        min: 0.8,
                        max: 1.4,
                        onChanged: (value) {
                          setState(() => _textSize = value);
                        },
                      ),
                    ),
                  ),
                  const Text(
                    'A',
                    style: TextStyle(fontSize: 24, color: Color(0xFF6A6670)),
                  ),
                ],
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

class _RadioChoice extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final Color activeColor;
  final ValueChanged<String> onChanged;

  const _RadioChoice({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            activeColor: activeColor,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final Color activeColor;
  final ValueChanged<String> onChanged;

  const _AppearanceOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: activeColor,
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: activeColor,
          inactiveThumbColor: const Color(0xFF807A87),
          inactiveTrackColor: const Color(0xFFE5DDF0),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

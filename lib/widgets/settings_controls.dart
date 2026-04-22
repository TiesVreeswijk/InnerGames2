import 'package:flutter/material.dart';

import '../theme/app_themeRyan.dart';

const _selectedSettingsColor = Color(0xFFCB2982);
const _unselectedSettingsColor = Color(0xFFE4007D);

WidgetStateProperty<Color> _settingsRadioFillColor() {
  return WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return _selectedSettingsColor;
    }

    return _unselectedSettingsColor;
  });
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTheme.settingsSectionTitle);
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppTheme.settingsDivider, thickness: 1);
  }
}

class SettingsOption<T> {
  final String label;
  final T value;

  const SettingsOption({
    required this.label,
    required this.value,
  });
}

class SettingsInlineRadioGroup<T> extends StatelessWidget {
  final List<SettingsOption<T>> options;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const SettingsInlineRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      child: Row(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 18),
            Expanded(
              child: _InlineRadioOption<T>(
                option: options[i],
                onTap: onChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SettingsVerticalRadioGroup<T> extends StatelessWidget {
  final List<SettingsOption<T>> options;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const SettingsVerticalRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      child: Column(
        children: options
            .map(
              (option) => _VerticalRadioOption<T>(
                option: option,
                onTap: onChanged,
              ),
            )
            .toList(),
      ),
    );
  }
}

class SettingsToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTheme.settingsSectionTitle),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: _selectedSettingsColor,
          inactiveThumbColor: _unselectedSettingsColor,
          inactiveTrackColor: _unselectedSettingsColor.withValues(
            alpha: 0.25,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _InlineRadioOption<T> extends StatelessWidget {
  final SettingsOption<T> option;
  final ValueChanged<T> onTap;

  const _InlineRadioOption({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onTap(option.value),
      child: Row(
        children: [
          Radio<T>(
            value: option.value,
            fillColor: _settingsRadioFillColor(),
          ),
          Expanded(
            child: Text(option.label, style: AppTheme.settingsOption),
          ),
        ],
      ),
    );
  }
}

class _VerticalRadioOption<T> extends StatelessWidget {
  final SettingsOption<T> option;
  final ValueChanged<T> onTap;

  const _VerticalRadioOption({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(option.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(option.label, style: AppTheme.settingsSubtle),
            ),
            Radio<T>(
              value: option.value,
              fillColor: _settingsRadioFillColor(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../widgets/name_input.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/app_themeRyan.dart';


class HostNameEntryScreen extends StatefulWidget {
  final String storyTitle;
  
  const HostNameEntryScreen({
    Key? key,
    required this.storyTitle,
  }) : super(key: key);

  @override
  State<HostNameEntryScreen> createState() => _HostNameEntryScreenState();
}

class _HostNameEntryScreenState extends State<HostNameEntryScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGame() async {
    final l10n = context.read<AppSettingsProvider>().l10n;
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tr('enter_name')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tr('name_too_short')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    const pin = '1234';

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/avatar-selection',
      arguments: {
        'pin': pin,
        'storyTitle': widget.storyTitle,
        'hostName': name,
        'isHost': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<AppSettingsProvider>().l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: NameInputWidget(
              title: l10n.tr('create_session_title'),
              titleStyle: AppTheme.entryScreenTitle,
              controller: _nameController,
              onSubmitted: _createGame,
              hintText: l10n.tr('name_hint'),
            ),
          ),
        ],
      ),
    );
  }
}

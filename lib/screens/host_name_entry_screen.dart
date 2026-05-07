import 'package:flutter/material.dart';
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
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The name must be at least 2 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final pin = '1234';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          
          SafeArea(
            child: NameInputWidget(
              title: 'Create a new session',
              titleStyle: AppTheme.entryScreenTitle,
              controller: _nameController,
              onSubmitted: _createGame,
            ),
          ),
        ],
      ),
    );
  }
}

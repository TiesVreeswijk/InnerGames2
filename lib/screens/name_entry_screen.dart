import 'package:flutter/material.dart';
import '../widgets/name_input.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/app_themeRyan.dart';

class NameEntryScreen extends StatefulWidget {
  final String pin;
  
  const NameEntryScreen({
    Key? key,
    required this.pin,
  }) : super(key: key);

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<State<NameInputWidget>> _nameInputKey = GlobalKey();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      _nameInputKey.currentState?.setState(() {});
      // Access the state to call shake
      (_nameInputKey.currentState as dynamic)?.shake();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.length < 2) {
      (_nameInputKey.currentState as dynamic)?.shake();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The name must be at least 2 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('Player joining with name: $name, PIN: ${widget.pin}');

    // Navigate to avatar selection
    Navigator.pushReplacementNamed(
      context,
      '/avatar-selection',
      arguments: {
        'playerName': name,
        'pin': widget.pin,
        'gameTitle': 'HET SKATEPARK',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: NameInputWidget(
          key: _nameInputKey,
          titleStyle: AppTheme.entryScreenTitle,
          title: 'Join session',
          controller: _nameController,
          onSubmitted: _continue,
        ),
      ),
    );
  }
}
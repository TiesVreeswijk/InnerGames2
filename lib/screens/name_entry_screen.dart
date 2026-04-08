import 'package:flutter/material.dart';
import '../widgets/name_input.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
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
      backgroundColor: const Color(0xF7F7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xDBDBDBDB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E7E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            
            const Text(
              'Sociality',
              style: TextStyle(
                color: Color(0xFF2C3E7E),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: NameInputWidget(
          title: 'Join session',
          controller: _nameController,
          onSubmitted: _continue,
        ),
      ),
    );
  }
}
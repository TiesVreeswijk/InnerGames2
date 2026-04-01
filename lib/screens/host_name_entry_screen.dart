import 'package:flutter/material.dart';

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
  bool _isCreating = false;

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

    setState(() {
      _isCreating = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    final pin = '1234';

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/host-share',
      arguments: {
        'pin': pin,
        'storyTitle': widget.storyTitle,
        'hostName': name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Create a new session',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E7E),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // SIMPLE Name input
              TextField(
                controller: _nameController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E7E),
                ),
                decoration: InputDecoration(
                  hintText: 'Your name',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                ),
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (_) => _createGame(),
              ),
          
              const SizedBox(height: 100), // Extra space for keyboard
            ],
          ),
        ),
      ),
    );
  }
}

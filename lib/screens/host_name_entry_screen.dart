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
      backgroundColor: const Color(0xF7F7F7F7),
      resizeToAvoidBottomInset: true,
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
            fit: BoxFit.contain,
            alignment: Alignment(0, -0.4),
            opacity: 0.5,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Title
              const Text(
                'Create a new session',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              
              const SizedBox(height: 93),

            // SIMPLE Name input - no fancy squares
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E7E),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      fontSize: 45,
                      color: Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFDBDBDB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 35,
                      horizontal: 24,
                    ),
                    counterText: '',
                  ),
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _createGame(),
                ),
                const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

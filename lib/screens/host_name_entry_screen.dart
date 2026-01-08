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
          content: Text('Voer je naam in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Naam moet minimaal 2 tekens zijn'),
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
              
              // Host icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Title
              const Text(
                'Wat is je naam?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E7E),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              const Text(
                'Je bent de host van dit spel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              
              const SizedBox(height: 48),
              
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
                  hintText: 'Je naam',
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
              
              const SizedBox(height: 24),
              
              // Create game button
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isCreating ? null : _createGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: _isCreating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                            'Spel aanmaken',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              
              const SizedBox(height: 100), // Extra space for keyboard
            ],
          ),
        ),
      ),
    );
  }
}

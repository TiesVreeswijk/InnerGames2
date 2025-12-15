
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'qr_scanner_screen.dart';

class JoinPinScreen extends StatefulWidget {
  const JoinPinScreen({Key? key}) : super(key: key);

  @override
  State<JoinPinScreen> createState() => _JoinPinScreenState();
}

class _JoinPinScreenState extends State<JoinPinScreen> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _joinGame() async {
    if (_pin.length == 4) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      final success = await gameProvider.joinGame(_pin, 'Player');
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Joined game successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid PIN code'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4A574),
      body: SafeArea(
        child: Container(
          // WHITE BACKGROUND CONTAINER
          margin: const EdgeInsets.only(top: 100),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Header bar (tan color)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFD4A574),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                      width: 40,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.favorite, size: 40, color: Color(0xFFE91E8C)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sociality',
                      style: TextStyle(
                        color: Color(0xFF3949AB),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 28),
                    ),
                  ],
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Deelnemen aan spel',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // PIN Display
              Text(
                _pin.isEmpty ? 'PIN' : _pin,
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: _pin.isEmpty ? Colors.grey[300] : Colors.black,
                  letterSpacing: 20,
                ),
              ),
              
              const Spacer(),
              
              // Join Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _pin.length == 4 ? _joinGame : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3949AB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Join game',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Toggle Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E8C),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Center(
                          child: Text(
                            'Pin invoeren',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRScannerScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5E6D3),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'QR-code scannen',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Number Pad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                    const SizedBox(), // Empty space
                    _buildNumberButton('0'),
                    _buildDeleteButton(),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _addDigit(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3949AB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _removeDigit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFF3949AB), width: 2),
        ),
      ),
      child: const Icon(
        Icons.backspace_outlined,
        size: 28,
        color: Color(0xFF3949AB),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class JoinPinScreen extends StatefulWidget {
  const JoinPinScreen({Key? key}) : super(key: key);

  @override
  State<JoinPinScreen> createState() => _JoinPinScreenState();
}

class _JoinPinScreenState extends State<JoinPinScreen> {
  String _pin = '';
  bool _isValidating = false;

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
      
      // Auto-validate when 4 digits entered
      if (_pin.length == 4) {
        _validateAndContinue();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _validateAndContinue() async {
    if (_pin.length != 4) return;

    setState(() {
      _isValidating = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isValidating = false;
    });

    // Go to name entry
    Navigator.pushReplacementNamed(
      context,
      '/lobby',
      arguments: {'pin': _pin},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Title
            const Text(
              'Deelnemen aan spel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // PIN Display - SIMPLE like old design (just big numbers)
            Text(
              _pin.isEmpty ? '' : _pin,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E7E),
                letterSpacing: 20,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Subtitle
            Text(
              'Voer de 4-cijferige PIN in',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            const Spacer(),
            
            // Number pad
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  // Rows 1-3
                  ...List.generate(3, (row) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: List.generate(3, (col) {
                          final number = (row * 3 + col + 1).toString();
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: _buildNumberButton(number),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                  
                  // Row 4: Empty, 0, Backspace
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildNumberButton('0'),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildBackspaceButton(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      height: 70,
      child: ElevatedButton(
        onPressed: _isValidating ? null : () => _addDigit(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C3E7E),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 2,
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return SizedBox(
      height: 70,
      child: ElevatedButton(
        onPressed: _isValidating || _pin.isEmpty ? null : _removeDigit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 2,
        ),
        child: Icon(
          Icons.backspace_outlined,
          color: _pin.isEmpty ? Colors.grey.shade400 : const Color(0xFF2C3E7E),
          size: 28,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HostShareScreen extends StatefulWidget {
  final String pin;
  final String storyTitle;
  final String hostName;
  
  const HostShareScreen({
    Key? key,
    required this.pin,
    required this.storyTitle,
    required this.hostName,
  }) : super(key: key);

  @override
  State<HostShareScreen> createState() => _HostShareScreenState();
}

class _HostShareScreenState extends State<HostShareScreen> {
  bool _showingPinCode = true;

  void _startGame() {
    // Navigate to lobby as host
    Navigator.pushReplacementNamed(
      context,
      '/lobby',
      arguments: {
        'isHost': true,
        'gameTitle': widget.storyTitle,
        'pin': widget.pin,
        'players': [widget.hostName], // Host is first player
        'hostName': widget.hostName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showingPinCode ? 'Deel Pin code' : 'Deel QR-code',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // PIN or QR Code Display
              if (_showingPinCode)
                _buildPinDisplay()
              else
                _buildQRDisplay(),
              
              const Spacer(),
              
              // Start Spel Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E7E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Start Spel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Toggle Buttons (Pin code / QR-code)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showingPinCode = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: _showingPinCode
                              ? const Color(0xFFE91E63)
                              : const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Pin code',
                          style: TextStyle(
                            color: _showingPinCode 
                                ? Colors.white 
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showingPinCode = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: !_showingPinCode
                              ? const Color(0xFFE91E63)
                              : const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'QR-code',
                          style: TextStyle(
                            color: !_showingPinCode 
                                ? Colors.white 
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinDisplay() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large PIN display
        Text(
          widget.pin,
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFF9800),
            letterSpacing: 20,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Deel deze code met spelers',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQRDisplay() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // QR Code
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              QrImageView(
                data: widget.pin, // In real app, use game session URL
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SCAN ME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Laat spelers deze QR-code scannen',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
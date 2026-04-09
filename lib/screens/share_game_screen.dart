import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ShareGameScreen extends StatefulWidget {
  const ShareGameScreen({super.key});

  @override
  State<ShareGameScreen> createState() => _HostShareScreenState();
}

class _HostShareScreenState extends State<ShareGameScreen> {
  bool showQrCode = false;

  final String pinCode = '21374';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    showQrCode ? 'Deel QR-code' : 'Deel Pin code',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Center(
                  child: showQrCode ? _buildQrPlaceholder() : _buildPinCode(),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/story');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF263A96),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Start Spel →',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E3E3),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ToggleButton(
                        text: 'Pin code',
                        selected: !showQrCode,
                        onTap: () {
                          setState(() {
                            showQrCode = false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _ToggleButton(
                        text: 'QR-code',
                        selected: showQrCode,
                        onTap: () {
                          setState(() {
                            showQrCode = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinCode() {
    return Text(
      pinCode,
      style: const TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF39A00),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildQrPlaceholder() {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.qr_code,
            size: 180,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'SOCIALITY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6007E) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
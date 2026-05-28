import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class JoinCodePanel extends StatefulWidget {
  final String pin;
  final String? title;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final bool compact;

  const JoinCodePanel({
    Key? key,
    required this.pin,
    this.title,
    this.showCloseButton = false,
    this.onClose,
    this.compact = false,
  }) : super(key: key);

  @override
  State<JoinCodePanel> createState() => _JoinCodePanelState();
}

class _JoinCodePanelState extends State<JoinCodePanel> {
  // No toggle state anymore — show both PIN and QR together.

  @override
  Widget build(BuildContext context) {
    final String title = widget.title ?? 'Deel code';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(title),

        SizedBox(height: widget.compact ? 24 : 36),

        // Show PIN and QR together
        _buildPinDisplay(key: const ValueKey('pin')),
        SizedBox(height: widget.compact ? 16 : 20),
        _buildQRDisplay(key: const ValueKey('qr')),

        SizedBox(height: widget.compact ? 24 : 36),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        if (widget.showCloseButton)
          GestureDetector(
            onTap: widget.onClose ?? () => Navigator.pop(context),
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
    );
  }

  Widget _buildPinDisplay({Key? key}) {
    final double pinFontSize = widget.compact ? 72 : 84;
    final double letterSpacing = widget.compact ? 14 : 18;

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.pin,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: pinFontSize,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFFF9800),
              letterSpacing: letterSpacing,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Deel deze code met spelers',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQRDisplay({Key? key}) {
    final double qrSize = widget.compact ? 180 : 200;

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              QrImageView(
                data: widget.pin,
                version: QrVersions.auto,
                size: qrSize,
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
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Toggle buttons removed — both PIN and QR are displayed above.
}
// Toggle removed — both PIN and QR are shown together now.
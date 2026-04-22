import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum JoinCodeView {
  pin,
  qr,
}

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
  JoinCodeView _selectedView = JoinCodeView.pin;

  bool get _showingPinCode => _selectedView == JoinCodeView.pin;

  void _setSelectedView(JoinCodeView view) {
    setState(() {
      _selectedView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.title ?? (_showingPinCode ? 'Deel Pin code' : 'Deel QR-code');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(title),

        SizedBox(height: widget.compact ? 32 : 48),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _showingPinCode
              ? _buildPinDisplay(key: const ValueKey('pin'))
              : _buildQRDisplay(key: const ValueKey('qr')),
        ),

        SizedBox(height: widget.compact ? 32 : 48),

        _buildToggleButtons(),
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

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: _JoinCodeToggleButton(
            text: 'Pin code',
            isSelected: _selectedView == JoinCodeView.pin,
            onTap: () => _setSelectedView(JoinCodeView.pin),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _JoinCodeToggleButton(
            text: 'QR-code',
            isSelected: _selectedView == JoinCodeView.qr,
            onTap: () => _setSelectedView(JoinCodeView.qr),
          ),
        ),
      ],
    );
  }
}

class _JoinCodeToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _JoinCodeToggleButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE91E63) : const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_themeRyan.dart';

class NameInputWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final TextStyle? titleStyle;

  const NameInputWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.onSubmitted,
    this.titleStyle,
  }) : super(key: key);

  @override
  State<NameInputWidget> createState() => _NameInputWidgetState();
}

class _NameInputWidgetState extends State<NameInputWidget> {
  bool _isTyping = false;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      final typingNow = widget.controller.text.isNotEmpty;

      if (typingNow != _isTyping) {
        setState(() {
          _isTyping = typingNow;
        });
      }
    };

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// TITLE
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: widget.titleStyle ??
                  const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),

            const SizedBox(height: 93),

            /// INPUT FIELD WITH ANIMATION
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: const Color(0xFFDBDBDB),
                borderRadius: BorderRadius.circular(16),

                // Animated border when typing
                border: Border.all(
                  color: _isTyping
                      ? AppTheme.primaryMagenta.withValues(alpha: 0.3):Color( 0xFFDBDBDB),
                  width: _isTyping ? 3 : 1,
                ),

                // Glow effect when typing
                boxShadow: _isTyping
                    ? [
                        BoxShadow(
                          color:
                              AppTheme.primaryMagenta.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: widget.controller,
                autofocus: true,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E7E),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 24,
                  ),
                  counterText: '',

                  /// Typewriter animation as hint (Eg: "Name" when not typing)
                  hint: _isTyping
                      ? null
                      : AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Name',
                              speed:
                                  const Duration(milliseconds: 130),
                              textStyle: TextStyle(
                                fontSize: 45,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                ),
                maxLength: 20,
                textCapitalization:
                    TextCapitalization.words,
                onSubmitted: (_) => widget.onSubmitted(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
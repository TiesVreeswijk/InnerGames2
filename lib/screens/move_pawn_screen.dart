// lib/screens/move_pawn_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../theme/app_themeRyan.dart';

class MovePawnScreen extends StatefulWidget {
  const MovePawnScreen({super.key});

  @override
  State<MovePawnScreen> createState() => _MovePawnScreenState();
}

class _MovePawnScreenState extends State<MovePawnScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;
  late final Animation<double> _bounceAnim;

  bool _popping = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.30, curve: Curves.easeIn),
    );

    _slideAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.10, 0.68, curve: Curves.easeInOut),
    );

    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -14.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 0.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -7.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -7.0, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0),
      ),
    );

    // Single forward pass — stops at 1.0, never loops
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_popping || !mounted) return;
    _popping = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<AppSettingsProvider>().l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              children: [
                const Spacer(),

                Text(
                  l10n.tr('move_pawn_title'),
                  textAlign: TextAlign.center,
                  style: AppTheme.entryScreenTitle,
                ),

                const SizedBox(height: 40),

                _PawnTrack(
                  slideAnim: _slideAnim,
                  bounceAnim: _bounceAnim,
                ),

                const SizedBox(height: 36),

                Text(
                  l10n.tr('move_pawn_description'),
                  textAlign: TextAlign.center,
                  style: AppTheme.welcomeBody,
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _onContinue,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.tr('move_pawn_continue')),
                    style: AppTheme.primaryButton.copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(AppTheme.primaryMagenta),
                      foregroundColor:
                          WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pawn track ───────────────────────────────────────────────────────────────

class _PawnTrack extends StatelessWidget {
  const _PawnTrack({required this.slideAnim, required this.bounceAnim});

  final Animation<double> slideAnim;
  final Animation<double> bounceAnim;

  @override
  Widget build(BuildContext context) {
    const pawnSize = 72.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final travelRange = constraints.maxWidth - pawnSize;
        const dotCount = 5;
        const dotSpacing = 1.0 / (dotCount - 1);

        return SizedBox(
          height: 110,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dashed track line
              Positioned(
                left: pawnSize / 2,
                right: pawnSize / 2,
                top: 43,
                child: CustomPaint(
                  size: Size(travelRange, 2),
                  painter: _DashedLinePainter(),
                ),
              ),

              // Dots that light up as pawn passes
              for (int i = 0; i < dotCount; i++)
                Positioned(
                  left: pawnSize / 2 + travelRange * (i * dotSpacing) - 6,
                  top: 38,
                  child: AnimatedBuilder(
                    animation: slideAnim,
                    builder: (_, __) {
                      final passed =
                          slideAnim.value >= (i * dotSpacing) - 0.05;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: passed
                              ? AppTheme.primaryMagenta
                              : const Color(0xFFBFBFBF),
                        ),
                      );
                    },
                  ),
                ),

              // Pawn — pure Flutter, no GIF
AnimatedBuilder(
  animation: Listenable.merge([slideAnim, bounceAnim]),
  builder: (_, __) {
    return Positioned(
      left: slideAnim.value * travelRange,
      top: bounceAnim.value,
      child: RepaintBoundary(
        child: Image.asset(
          'assets/gifs/wired-lineal-1482-chess-pawn.gif',
          width: pawnSize,
          height: pawnSize,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          filterQuality: FilterQuality.low,
        ),
      ),
    );
  },
),
            ],
          ),
        );
      },
    );
  }
}



// ─── Dashed line ──────────────────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBFBFBF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashGap = 5.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + dashWidth).clamp(0.0, size.width), 0),
        paint,
      );
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
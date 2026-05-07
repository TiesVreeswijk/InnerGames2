import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/animated_pop_button_effect.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreenv2 extends StatefulWidget {
  const HomeScreenv2({super.key});

  @override
  State<HomeScreenv2> createState() => _HomeScreenv2State();
}

class _HomeScreenv2State extends State<HomeScreenv2> {
  bool _startBackgroundEffect = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _startBackgroundEffect = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _showContent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(showBackButton: false),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. LOGO WATERMARK EFFECT
          Positioned.fill(
            child: Center(
              child: Hero(
                tag: 'mainLogo',
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1200),
                  opacity: _startBackgroundEffect ? 0.1 : 1.0,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
          ),

          // 2. MAIN BUTTONS
          if (_showContent)
            AnimationLimiter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 100.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    _buildMenuButton(context, 'Play', Icons.play_arrow, '/create-join'),
                    const SizedBox(height: 16),
                    _buildMenuButton(context, 'Scan', Icons.qr_code_scanner, null),
                    const SizedBox(height: 16),
                    _buildMenuButton(context, 'Settings', Icons.settings, '/settings'),
                  ],
                ),
              ),
            ),

          // 3. FOOTER LOGO
          if (_showContent)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: AnimationLimiter(
                  child: AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      verticalOffset: 80.0,
                      child: FadeInAnimation(
                        child: Image.asset(
                          'assets/images/innergames logo.png',
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String label, IconData icon, String? route) {
    return AnimatedPressButton(
      onPressed: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: FilledButton.icon(
        // onPressed is intentionally null here; AnimatedPressButton handles the tap
        onPressed: null,
        icon: Icon(icon),
        label: Text(label),
        style: AppTheme.primaryButton.copyWith(
          // Keep the magenta colour even when onPressed is null (disabled state)
          backgroundColor: WidgetStateProperty.all(AppTheme.primaryMagenta),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
    );
  }
}
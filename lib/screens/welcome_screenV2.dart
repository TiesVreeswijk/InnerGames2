import 'package:flutter/material.dart';
import 'package:tweekracht_sociality/screens/home_screenV2.dart';
import '../theme/app_themeRyan.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WelcomeScreenv2 extends StatefulWidget {
  const WelcomeScreenv2({super.key});

  @override
  State<WelcomeScreenv2> createState() => _WelcomeScreenv2State();
}

class _WelcomeScreenv2State extends State<WelcomeScreenv2> {
  bool _isExiting = false;

void _onNextPressed() async {
  setState(() => _isExiting = true); 
  
  // Wait for the logo to move to the absolute center
  await Future.delayed(const Duration(milliseconds: 600)); 
  
  if (!mounted) return;

  // Use a FadeTransition so the Hero logo can fly smoothly
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomeScreenv2(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
    (route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimationLimiter(
        child: Stack(
          children: [
            // 1. LOGO SECTION
            // We use AnimatedAlign so it moves to center when _isExiting is true
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              alignment: _isExiting ? Alignment.center : const Alignment(0, -0.4),
              child: Hero(
                tag: 'mainLogo',
                // Keep the logo clean of staggered animations to avoid the "block" error during Hero flight
                child: Image.asset('assets/images/logo.png', width: 180),
              ),
            ),

            // 2. TOASTER SECTION
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              bottom: _isExiting ? -500 : 0, 
              left: 0,
              right: 0,
              child: AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  verticalOffset: 500,
                  child: Container(
                    height: screenHeight * 0.45,
                    decoration: AppTheme.bottomSheetDecoration,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 400),
                        childAnimationBuilder: (widget) => FadeInAnimation(child: widget),
                        children: [
                          const Text('Welkom!', style: AppTheme.welcomeTitle),
                          const SizedBox(height: 16),
                          const Text(
                            'Verken sociale werksituaties en ontdek wat je kunt doen.',
                            textAlign: TextAlign.center,
                            style: AppTheme.welcomeBody,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _onNextPressed,
                              style: AppTheme.primaryButton,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Volgende'),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Image.asset('assets/images/innergames logo.png', width: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
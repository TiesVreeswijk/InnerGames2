import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WelcomeScreenv2 extends StatelessWidget {
  const WelcomeScreenv2({super.key});

  @override
  Widget build(BuildContext context) {
    // We calculate the offset to push the logo to the center of the screen
    final screenHeight = MediaQuery.of(context).size.height;

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        // Remove bottom padding if the theme adds it to ensure toaster hits the edge
        bottomNavigationBar: null, 
        body: AnimationLimiter(
          child: Column(
            children: [
              // 1. TOP SECTION (Logo)
              Expanded(
                flex: 5, // Increased flex to give the logo more space
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 1000),
                  child: SlideAnimation(
                    // This offset pushes it down to center, then it slides "up" to home
                    verticalOffset: screenHeight * 0.25, 
                    child: FadeInAnimation(
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 180, // Reduced width to match design
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. BOTTOM SECTION (The Toaster object)
              Expanded(
                flex: 5, 
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 900),
                  child: SlideAnimation(
                    verticalOffset: 500.0, // Slides up from way below, Like we start the object really down and it slides up to the bottom of the screen.
                    child: Container(
                      width: double.infinity,
                      // The decoration should fill the entire Expanded area
                      decoration: AppTheme.bottomSheetDecoration, 
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        // This centers  items vertically inside the toaster
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 500),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 20.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            const Text(
                              'Welkom!',
                              style: AppTheme.welcomeTitle,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Verken sociale werksituaties en ontdek wat je kunt doen.',
                              textAlign: TextAlign.center,
                              style: AppTheme.welcomeBody,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity, // wide like inf of the "volgende" button. Make sure it use entire content space of the toaster.
                              child: FilledButton.icon(
                                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                  context, '/home', (route) => false,
                                ),
                                style: AppTheme.primaryButton,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Volgende'),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Image.asset(
                              'assets/images/innergames logo.png',
                              width: 60,
                            ),
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
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/animated_pop_button_effect.dart';
import '../theme/app_themeRyan.dart';
import 'dart:math' as math;

final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

class CreateJoinScreen extends StatefulWidget {
  const CreateJoinScreen({super.key});

  @override
  State<CreateJoinScreen> createState() => _CreateJoinScreenState();
}

class _CreateJoinScreenState extends State<CreateJoinScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _bounceController;
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _startBounceAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route is PageRoute && route != _route) {
      if (_route != null) {
        routeObserver.unsubscribe(this);
      }
      _route = route;
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _startBounceAnimation();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _bounceController.dispose();
    super.dispose();
  }

  void _startBounceAnimation() {
    _bounceController.forward(from: 0);
  }

  Widget _buildBouncingButton({
    required double phase,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _bounceController,
      child: child,
      builder: (context, child) {
        final t = _bounceController.value;
        final cycles = 3.0;
        final amplitude = 8.0 * math.pow(0.45, t * cycles).toDouble();
        final offsetY = math.sin((t * math.pi * 2 * cycles) + phase) * -amplitude;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Logo (Watermark)
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBouncingButton(
                    phase: 0,
                    child: AnimatedPressButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/host-name-entry');
                      },
                      child: FilledButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.link),
                        label: const Text('Create'),
                        style: AppTheme.primaryButton.copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(AppTheme.primaryMagenta),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 56),

                  _buildBouncingButton(
                    phase: math.pi / 2,
                    child: AnimatedPressButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/name-entry');
                      },
                      child: FilledButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.add),
                        label: const Text('Join'),
                        style: AppTheme.primaryButton.copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(AppTheme.primaryMagenta),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Static Footer Logo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset(
                'assets/images/innergames logo.png',
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

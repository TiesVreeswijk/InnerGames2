import 'package:flutter/material.dart';

/// A wrapper that adds a "pop" press animation to any button.
///
/// On tap-down  > scales UP  to [scaleUp]   (snappy, 80 ms)
/// On tap-up    > springs back to 1.0        (bouncy, 250 ms elastic)
/// On tap-cancel > quietly returns to 1.0
///
/// Usage – just wrap any widget:
///
///   AnimatedPressButton(
///     onPressed: () => ...,
///     child: FilledButton.icon(...),
///   )
/// 
/// It's ment to be reuseable for any button, feel free to wrap TextButtons, IconButtons, or even custom widgets!
class AnimatedPressButton extends StatefulWidget {
  const AnimatedPressButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleUp = 1.08,
  });

  final Widget child;
  final VoidCallback? onPressed;

  /// How much the button grows on press. 1.08 = 8 % larger.
  final double scaleUp;

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this, // set on hz of the screen refresh rate
      duration: const Duration(milliseconds: 200),   // snap up fast …
      reverseDuration: const Duration(milliseconds: 250), // … bounce back slow
    );

    _scale = Tween<double>(begin: 1.0, end: widget.scaleUp).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.elasticOut, // the "bounce" on release
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  Future<void> _onTapUp(TapUpDetails _) async {
    // Let the full bounce play out, THEN navigate/call the action
    await _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: _onTapCancel,
      // Remove the default ink-splash so it doesn't fight our scale effect
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
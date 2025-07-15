// Advanced Micro-Interactions System for Astacala Rescue Mobile
// Provides smooth, delightful interactions throughout the app

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MicroInteractions {
  // Hero animation for screen transitions
  static Widget heroTransition({
    required String tag,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: child,
    );
  }

  // Staggered animation for list items
  static Widget staggeredListAnimation({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * delay.inMilliseconds)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Card reveal animation
  static Widget cardRevealAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(3.14159 * (1 - value))
            ..scale(value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Pulse animation for important elements
  static Widget pulseAnimation({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (0.1 * (0.5 - (value - 0.5).abs()) * 2),
          child: child,
        );
      },
      onEnd: () {
        // Restart animation
      },
      child: child,
    );
  }

  // Slide transition for page navigation
  static PageRouteBuilder slideTransition({
    required Widget page,
    SlideDirection direction = SlideDirection.left,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.left:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.right:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }

        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Ripple effect for buttons
  static Widget rippleEffect({
    required Widget child,
    required VoidCallback onTap,
    Color? rippleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        splashColor:
            rippleColor ?? const Color(0xFF8B0000).withValues(alpha: 0.2),
        highlightColor:
            rippleColor ?? const Color(0xFF8B0000).withValues(alpha: 0.1),
        child: child,
      ),
    );
  }

  // Bounce animation for interactions
  static Widget bounceAnimation({
    required Widget child,
    required VoidCallback onTap,
    double scale = 0.95,
  }) {
    return _BounceWidget(
      onTap: onTap,
      scale: scale,
      child: child,
    );
  }

  // Shimmer loading effect
  static Widget shimmerLoading({
    required Widget child,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value,
                (value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      onEnd: () {
        // Restart animation
      },
      child: child,
    );
  }

  // Scale transition with fade
  static Widget scaleTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Floating animation for FABs and important elements
  static Widget floatingAnimation({
    required Widget child,
    Duration duration = const Duration(seconds: 3),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (0.5 - (value - 0.5).abs()) * 2),
          child: child,
        );
      },
      onEnd: () {
        // Restart animation
      },
      child: child,
    );
  }

  // Typewriter text animation
  static Widget typewriterText({
    required String text,
    required TextStyle style,
    Duration duration = const Duration(milliseconds: 50),
  }) {
    return _TypewriterText(
      text: text,
      style: style,
      duration: duration,
    );
  }

  // Progress indicator with animation
  static Widget animatedProgress({
    required double progress,
    Color color = const Color(0xFF8B0000),
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: progress),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        );
      },
    );
  }
}

enum SlideDirection { left, right, up, down }

// Bounce Widget Implementation
class _BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;

  const _BounceWidget({
    required this.child,
    required this.onTap,
    this.scale = 0.95,
  });

  @override
  State<_BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<_BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

// Typewriter Text Implementation
class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const _TypewriterText({
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 50),
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: widget.text.length * widget.duration.inMilliseconds,
      ),
      vsync: this,
    );

    _characterAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterAnimation,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _characterAnimation.value),
          style: widget.style,
        );
      },
    );
  }
}

// Enhanced Page Transition for App Navigation
class EnhancedPageTransition extends PageRouteBuilder {
  final Widget page;
  final PageTransitionType type;

  EnhancedPageTransition({
    required this.page,
    this.type = PageTransitionType.slideFromRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (type) {
              case PageTransitionType.fade:
                return FadeTransition(opacity: animation, child: child);
              case PageTransitionType.scale:
                return ScaleTransition(scale: animation, child: child);
              case PageTransitionType.slideFromRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: child,
                );
              case PageTransitionType.slideFromBottom:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: child,
                );
              case PageTransitionType.rotation:
                return RotationTransition(
                  turns: animation,
                  child: child,
                );
            }
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

enum PageTransitionType {
  fade,
  scale,
  slideFromRight,
  slideFromBottom,
  rotation,
}

// Animated Counter Widget
class AnimatedCounter extends StatefulWidget {
  final int count;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.count,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.count).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _previousCount = _animation.value;
      _animation = IntTween(begin: _previousCount, end: widget.count).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toString(),
          style: widget.style,
        );
      },
    );
  }
}

// Breathing animation for important notifications
class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BreathingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

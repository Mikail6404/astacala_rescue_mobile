// Micro-interactions and Advanced Animations - Feature 5
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MicroInteractions {
  // Hero animation for disaster cards
  static Widget heroDisasterCard({
    required String heroTag,
    required Widget child,
  }) {
    return Hero(
      tag: heroTag,
      child: child,
    );
  }

  // Animated page transition
  static Route<T> createRoute<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          )),
          child: child,
        );
      },
    );
  }

  // Fade transition for overlay screens
  static Route<T> createFadeRoute<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Scale transition for modal dialogs
  static Route<T> createScaleRoute<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: child,
        );
      },
    );
  }

  // Animated navigation helper
  static void navigateWithAnimation(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context)
        .push(createRoute(page, duration: duration, curve: curve));
  }

  static void navigateWithFade(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    Navigator.of(context).push(createFadeRoute(page, duration: duration));
  }

  static void navigateWithScale(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    Navigator.of(context).push(createScaleRoute(page, duration: duration));
  }
}

// Animated Card Widget with micro-interactions
class AnimatedInteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double elevationOnHover;
  final double scaleOnTap;

  const AnimatedInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
    this.elevationOnHover = 8.0,
    this.scaleOnTap = 0.95,
  });

  @override
  State<AnimatedInteractiveCard> createState() =>
      _AnimatedInteractiveCardState();
}

class _AnimatedInteractiveCardState extends State<AnimatedInteractiveCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _elevationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnTap,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: widget.elevationOnHover,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  void _onHoverEnter(PointerEnterEvent event) {
    setState(() {
      _isHovered = true;
    });
    _elevationController.forward();
  }

  void _onHoverExit(PointerExitEvent event) {
    setState(() {
      _isHovered = false;
    });
    _elevationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onHoverEnter,
      onExit: _onHoverExit,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleController, _elevationController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Card(
                elevation: _elevationAnimation.value,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Animated List Item with slide-in animation
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Staggered animation based on index
    Future.delayed(
      Duration(milliseconds: widget.index * widget.delay.inMilliseconds),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Floating Action Button with ripple effect
class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final String heroTag;

  const AnimatedFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = const Color(0xFF8B0000),
    this.heroTag = 'fab',
  });

  @override
  State<AnimatedFloatingActionButton> createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: FloatingActionButton(
              onPressed: null, // Handled by GestureDetector
              backgroundColor: widget.backgroundColor,
              heroTag: widget.heroTag,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// Bouncing scroll physics for enhanced pull-to-refresh
class BouncingScrollPhysics extends ScrollPhysics {
  const BouncingScrollPhysics({super.parent});

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double frictionFactor(double overscrollFraction) => 0.52;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // underscroll
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // overscroll
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // hit top edge
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // hit bottom edge
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }
      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }
      if (end != null) {
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          end,
          velocity,
          tolerance: tolerance,
        );
      }
    }
    return super.createBallisticSimulation(position, velocity);
  }
}

// Animated Bottom Sheet
class AnimatedBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: duration,
        vsync: Navigator.of(context),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}

// Staggered Animation Widget
class StaggeredAnimationWidget extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration duration;

  const StaggeredAnimationWidget({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<StaggeredAnimationWidget> createState() =>
      _StaggeredAnimationWidgetState();
}

class _StaggeredAnimationWidgetState extends State<StaggeredAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return AnimatedListItem(
          index: index,
          delay: widget.delay,
          child: child,
        );
      }).toList(),
    );
  }
}

// Ripple animation widget
class RippleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color rippleColor;

  const RippleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor = Colors.white,
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward().then((_) {
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startAnimation();
        widget.onTap?.call();
      },
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    progress: _animation.value,
                    color: widget.rippleColor.withOpacity(0.3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        (size.width > size.height ? size.width : size.height) * progress;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

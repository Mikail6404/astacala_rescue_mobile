// lib/widgets/enhanced_loading_states.dart

import 'package:flutter/material.dart';
import 'package:astacala_rescue_mobile/utils/app_colors.dart';
import 'package:astacala_rescue_mobile/utils/app_spacing.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.neutral90;
    final highlightColor = widget.highlightColor ?? AppColors.neutral95;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform:
                  _SlidingGradientTransform(slidePercent: _animation.value),
            ).createShader(rect);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class DisasterCardSkeleton extends StatelessWidget {
  const DisasterCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.neutral95,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutral90,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
            ),
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.neutral90,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  AppSpacing.verticalSpaceMd,
                  // Subtitle placeholder
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.neutral90,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  AppSpacing.verticalSpaceLg,
                  // Button row placeholder
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.neutral90,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                      ),
                      AppSpacing.horizontalSpaceMd,
                      Container(
                        width: 60,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.neutral90,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.primary;
    final textColor = widget.textColor ?? AppColors.onPrimary;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Container(
              height: AppSpacing.buttonHeight,
              decoration: BoxDecoration(
                gradient: widget.isLoading
                    ? null
                    : LinearGradient(
                        colors: [
                          backgroundColor,
                          AppColors.lighten(backgroundColor, 0.1)
                        ],
                      ),
                color: widget.isLoading ? AppColors.neutral70 : null,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: widget.isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: backgroundColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(textColor),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: textColor, size: 20),
                              AppSpacing.horizontalSpaceSm,
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NetworkImageWithLoading extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWithLoading({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<NetworkImageWithLoading> createState() =>
      _NetworkImageWithLoadingState();
}

class _NetworkImageWithLoadingState extends State<NetworkImageWithLoading> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: AppColors.neutral95,
        child: Stack(
          children: [
            if (!_hasError)
              Image.network(
                widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  _hasError = true;
                  return _buildErrorState();
                },
              ),
            if (_hasError) _buildErrorState(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppColors.neutral90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: AppColors.neutral60,
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            'Gagal memuat gambar',
            style: TextStyle(
              color: AppColors.neutral60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

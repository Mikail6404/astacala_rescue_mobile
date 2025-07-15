// lib/widgets/enhanced_error_handling.dart

import 'package:flutter/material.dart';
import 'package:astacala_rescue_mobile/utils/app_colors.dart';
import 'package:astacala_rescue_mobile/utils/app_spacing.dart';
import 'package:astacala_rescue_mobile/utils/app_typography.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool showImage;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showImage) ...[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXxxl),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 60,
                  color: AppColors.error,
                ),
              ),
              AppSpacing.verticalSpaceXxxl,
            ],
            Text(
              title,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceLg,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onRetry != null) ...[
              AppSpacing.verticalSpaceXxxl,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(buttonText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xxl,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Koneksi Bermasalah',
      message: 'Periksa koneksi internet Anda dan coba lagi',
      buttonText: 'Coba Lagi',
      onRetry: onRetry,
      icon: Icons.wifi_off_outlined,
    );
  }
}

class EmptyDataWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData? icon;

  const EmptyDataWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: title,
      message: message,
      buttonText: buttonText,
      onRetry: onAction,
      icon: icon ?? Icons.inbox_outlined,
      showImage: true,
    );
  }
}

class ErrorSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.onError.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Icon(
                Icons.error_outline,
                color: AppColors.onError,
                size: AppSpacing.iconSizeSmall,
              ),
            ),
            AppSpacing.horizontalSpaceMd,
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        margin: AppSpacing.paddingLg,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.onError,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }
}

class SuccessSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.onSuccess.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: AppColors.onSuccess,
                size: AppSpacing.iconSizeSmall,
              ),
            ),
            AppSpacing.horizontalSpaceMd,
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSuccess,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        margin: AppSpacing.paddingLg,
      ),
    );
  }
}

class WarningDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warningContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Icon(
                  Icons.warning_outlined,
                  color: AppColors.warning,
                  size: AppSpacing.iconSizeMedium,
                ),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headlineSmall,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
              ),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.onWarning,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}

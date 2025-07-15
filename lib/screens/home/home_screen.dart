// package:astacala_rescue_mobile/screens/home/home_screen.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/widgets/disaster_card.dart';
import 'package:astacala_rescue_mobile/widgets/search_filter_bottom_sheet.dart';
import 'package:astacala_rescue_mobile/widgets/notification_badge.dart';
import 'package:astacala_rescue_mobile/widgets/quick_actions_widget.dart';
import 'package:astacala_rescue_mobile/widgets/enhanced_loading_states.dart';
import 'package:astacala_rescue_mobile/screens/notification/notification_screen.dart';
import 'package:astacala_rescue_mobile/utils/app_colors.dart';
import 'package:astacala_rescue_mobile/utils/app_spacing.dart';
import 'package:astacala_rescue_mobile/utils/app_typography.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;

  // Create mock data to build the UI without a backend
  final List<DisasterReportCardModel> mockReports = [
    DisasterReportCardModel(
      title: 'Gempa Bumi Cisompet Kota Garut',
      imageUrl:
          'https://images.unsplash.com/photo-1593954842101-26615b3c3634?w=500',
      commentCount: 12,
      weatherCondition: 'Cerah',
      temperature: 27,
    ),
    DisasterReportCardModel(
      title: 'Tanggap Bencana Banjir di Bekasi',
      imageUrl:
          'https://images.unsplash.com/photo-1567429124266-60a7343a4e9?w=500',
      commentCount: 8,
      weatherCondition: 'Hujan',
      temperature: 24,
    ),
    DisasterReportCardModel(
      title: 'Longsor di Daerah Cianjur',
      imageUrl:
          'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=500',
      commentCount: 15,
      weatherCondition: 'Mendung',
      temperature: 22,
    ),
    DisasterReportCardModel(
      title: 'Kebakaran Hutan Sukabumi',
      imageUrl:
          'https://images.unsplash.com/photo-1574482620888-1ad6bbacfb31?w=500',
      commentCount: 6,
      weatherCondition: 'Cerah',
      temperature: 31,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement refresh functionality with backend
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Hero Section with Gradient Background
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSpacing.radiusXxxl),
                          bottomRight: Radius.circular(AppSpacing.radiusXxxl),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: AppSpacing.screenPaddingAll,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      color: AppColors.onPrimary
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusLg),
                                    ),
                                    child: Icon(
                                      Icons.shield_outlined,
                                      color: AppColors.onPrimary,
                                      size: AppSpacing.iconSizeLarge,
                                    ),
                                  ),
                                  AppSpacing.horizontalSpaceMd,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hai, Sobat Relawan',
                                          style: AppTypography.displaySmall
                                              .copyWith(
                                            color: AppColors.onPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Siap membantu kapan saja',
                                          style:
                                              AppTypography.bodyMedium.copyWith(
                                            color: AppColors.onPrimary
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  NotificationBadge(
                                    count: NotificationService.getUnreadCount(),
                                    icon: Icons.notifications_outlined,
                                    iconColor: AppColors.onPrimary,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              AppSpacing
                                  .verticalSpaceXl, // Reduced from Xxl to Xl
                              // Enhanced Emergency Stats Row with responsive design
                              Row(
                                children: [
                                  Expanded(
                                    child: IntrinsicHeight(
                                      // Add IntrinsicHeight for equal heights
                                      child: _buildEnhancedStatCard(
                                        'Laporan Aktif',
                                        '12',
                                        Icons.report_problem,
                                        AppColors.warning,
                                      ),
                                    ),
                                  ),
                                  AppSpacing
                                      .horizontalSpaceSm, // Reduced from Md to Sm
                                  Expanded(
                                    child: IntrinsicHeight(
                                      // Add IntrinsicHeight for equal heights
                                      child: _buildEnhancedStatCard(
                                        'Tim Siaga',
                                        '8',
                                        Icons.group,
                                        AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Main Content with Enhanced Spacing
                    Padding(
                      padding: AppSpacing.screenPaddingAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Search Bar
                          _buildEnhancedSearchBar(),

                          AppSpacing.verticalSpaceXxl,

                          // Quick Actions Section
                          const QuickActionsWidget(),

                          AppSpacing.verticalSpaceXxl,

                          // Enhanced Section Header
                          _buildSectionHeader(
                            title: 'Bencana Terkini',
                            actionText: 'Lihat Semua',
                            onActionPressed: () {
                              // TODO: Navigate to all reports
                            },
                          ),

                          AppSpacing.verticalSpaceLg,

                          // Enhanced Disaster Cards List
                          _isLoading
                              ? _buildLoadingCards()
                              : _buildDisasterCards(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md), // Reduced from lg to md
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.onPrimary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(
                    AppSpacing.xs), // Reduced from sm to xs
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AppSpacing.iconSizeSmall,
                ),
              ),
              AppSpacing.horizontalSpaceXs, // Reduced from sm to xs
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    // Changed from labelMedium to labelSmall
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceXs, // Reduced from sm to xs
          Flexible(
            // Wrap in Flexible to prevent overflow
            child: Text(
              value,
              style: AppTypography.headlineMedium.copyWith(
                // Changed from headlineLarge to headlineMedium
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari berita rescue terkini...',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.onSurfaceVariant,
            size: AppSpacing.iconSizeMedium,
          ),
          suffixIcon: InkWell(
            onTap: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SearchFilterBottomSheet(),
              );
              if (result != null) {
                // TODO: Apply filters to search results
                // Filter logic: Apply result filters to disaster list
              }
            },
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                Icons.tune,
                color: AppColors.onPrimary,
                size: AppSpacing.iconSizeSmall,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onActionPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        TextButton.icon(
          onPressed: onActionPressed,
          icon: Icon(
            Icons.arrow_forward,
            size: AppSpacing.iconSizeSmall,
          ),
          label: Text(actionText),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCards() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceLg,
      itemBuilder: (context, index) {
        return const DisasterCardSkeleton();
      },
    );
  }

  Widget _buildDisasterCards() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockReports.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceLg,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: DisasterCard(report: mockReports[index]),
              ),
            );
          },
        );
      },
    );
  }
}

// package:astacala_rescue_mobile/screens/home/home_screen.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/widgets/disaster_card_enhanced.dart';
import 'package:astacala_rescue_mobile/widgets/search_filter_bottom_sheet.dart';
import 'package:astacala_rescue_mobile/widgets/notification_badge.dart';
import 'package:astacala_rescue_mobile/widgets/quick_actions_widget.dart';
import 'package:astacala_rescue_mobile/widgets/feedback_animations.dart';
import 'package:astacala_rescue_mobile/widgets/micro_interactions.dart';
import 'package:astacala_rescue_mobile/screens/notification/notification_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Show loading feedback
        FeedbackAnimations.showInfo(
          context,
          message: 'Memperbarui data bencana...',
        );

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Show success feedback
        FeedbackAnimations.showSuccess(
          context,
          message: 'Data berhasil diperbarui',
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Gradient Background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B0000),
                    const Color(0xFF8B0000).withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai, Sobat Relawan',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Siap membantu kapan saja',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        NotificationBadge(
                          count: NotificationService.getUnreadCount(),
                          icon: Icons.notifications_outlined,
                          iconColor: Colors.white,
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
                    const SizedBox(height: 24),
                    // Emergency Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                              'Laporan Aktif', '12', Icons.report_problem),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard('Tim Siaga', '8', Icons.group),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar with Enhanced Design
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari berita rescue terkini...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        suffixIcon: InkWell(
                          onTap: () async {
                            final result = await showModalBottomSheet<
                                Map<String, dynamic>>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const SearchFilterBottomSheet(),
                            );
                            if (result != null) {
                              // TODO: Apply filters to search results
                              print('Filters applied: $result');
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B0000),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.tune,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions Section
                  const QuickActionsWidget(),

                  // Section Header with Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bencana Terkini',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Navigate to all reports
                        },
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('Lihat Semua'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Disaster Cards List
                  StaggeredAnimationWidget(
                    children: mockReports.asMap().entries.map((entry) {
                      return DisasterCard(
                        report: entry.value,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

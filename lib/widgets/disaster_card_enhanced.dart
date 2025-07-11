// package:astacala_rescue_mobile/widgets/disaster_card.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/screens/detail/detail_screen.dart';
import 'package:astacala_rescue_mobile/widgets/micro_interactions.dart';
import 'package:flutter/material.dart';

class DisasterCard extends StatelessWidget {
  final DisasterReportCardModel report;

  const DisasterCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'disaster_card_${report.title}_${report.commentCount}',
      child: AnimatedInteractiveCard(
        onTap: () {
          MicroInteractions.navigateWithAnimation(
            context,
            DetailScreen(report: report),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section with hero animation
                Stack(
                  children: [
                    Hero(
                      tag: 'disaster_image_${report.title}',
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              report.imageUrl,
                            ),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Handle image load error
                            },
                          ),
                        ),
                      ),
                    ),

                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Badge and status overlay
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'URGENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Weather info overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getWeatherIcon(report.weatherCondition),
                              size: 16,
                              color: const Color(0xFF8B0000),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${report.weatherCondition} ${report.temperature}°C',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Stats row
                      Row(
                        children: [
                          // Comments
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${report.commentCount}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Severity indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tinggi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Action button with ripple effect
                          RippleAnimation(
                            onTap: () {
                              MicroInteractions.navigateWithAnimation(
                                context,
                                DetailScreen(report: report),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B0000),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Detail',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 14),
                                ],
                              ),
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
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'cerah':
        return Icons.wb_sunny;
      case 'hujan':
        return Icons.water_drop;
      case 'berawan':
        return Icons.cloud;
      case 'mendung':
        return Icons.cloud_queue;
      default:
        return Icons.wb_sunny;
    }
  }
}

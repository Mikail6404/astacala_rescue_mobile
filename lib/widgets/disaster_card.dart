// package:astacala_rescue_mobile/widgets/disaster_card.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';

class DisasterCard extends StatelessWidget {
  final DisasterReportCardModel report;

  const DisasterCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Weather Overlay
          Stack(
            children: [
              Image.network(
                report.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                // Basic error and loading widgets for network images
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 180),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${report.weatherCondition} ${report.temperature}°',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('${report.commentCount} Comment', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // This is the navigation logic that was added
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(report: report),
                          ),
                        );
                      },
                      child: const Text('Detail Bencana', style: TextStyle(color: Color(0xFF8B0000))),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
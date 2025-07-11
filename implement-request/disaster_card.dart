// package:astacala_rescue_mobile/widgets/disaster_card.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
// Import the new detail screen
import 'package:astacala_rescue_mobile/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';

class DisasterCard extends StatelessWidget {
  final DisasterReportCardModel report;

  const DisasterCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      // ... (keep all existing Card styling)
      child: Column(
        children: [
          // ... (keep the Stack with the Image)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (keep the Text for the title)
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ... (keep the Row for the comment count)
                    TextButton(
                      onPressed: () {
                        // --- Add this navigation logic ---
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(report: report),
                          ),
                        );
                        // ------------------------------------
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
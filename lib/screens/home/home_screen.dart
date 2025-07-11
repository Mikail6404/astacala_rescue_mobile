// package:astacala_rescue_mobile/screens/home/home_screen.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/widgets/disaster_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Fix #2: Removed 'const' from the constructor because 'mockReports' is not a const field.
  HomeScreen({super.key});

  // Create mock data to build the UI without a backend
  final List<DisasterReportCardModel> mockReports = [
    DisasterReportCardModel(
      title: 'Gempa Bumi Cisompet Kota Garut',
      imageUrl: 'https://images.unsplash.com/photo-1593954842101-26615b3c3634?w=500', // Placeholder
      commentCount: 10,
      // Fix #1: Added the required arguments for weatherCondition and temperature.
      weatherCondition: 'Cerah',
      temperature: 27,
    ),
    DisasterReportCardModel(
      title: 'Tanggap Bencana Banjir di Bekasi',
      imageUrl: 'https://images.unsplash.com/photo-1567429124266-60a7f343a4e9?w=500', // Placeholder
      commentCount: 5,
      // Fix #1: Added the required arguments for weatherCondition and temperature.
      weatherCondition: 'Hujan',
      temperature: 24,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Greeting Text ---
        const Text(
          'Hai, Sobat Relawan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // --- Search Bar ---
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari berita rescue terkini',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 24),
        // --- Section Title ---
        const Text(
          'Bencana Terkini',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // --- List of Disaster Cards ---
        ListView.builder(
          itemCount: mockReports.length,
          shrinkWrap: true, // Important for nested ListViews
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling of the inner list
          itemBuilder: (context, index) {
            return DisasterCard(report: mockReports[index]);
          },
        ),
      ],
    );
  }
}
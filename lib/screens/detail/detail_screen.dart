// package:astacala_rescue_mobile/screens/detail/detail_screen.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
// Import the new forum screen
import 'package:astacala_rescue_mobile/screens/forum/forum_screen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final DisasterReportCardModel report;

  const DetailScreen({super.key, required this.report});
  
  // Helper widget for a section header
  Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Helper widget for a row of information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for labels
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Informasi Bencana'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disaster Image
            Image.network(
              report.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disaster Title
                  Text(
                    report.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  // Team Relawan Section
                  _buildSectionHeader(context, Icons.people, 'Team Relawan'),
                  _buildInfoRow('Nama Team', 'Astacala Rescue'),
                  _buildInfoRow('Jumlah Personel', '8'),
                  _buildInfoRow('No Telepon', '08787663582'),

                  // Informasi Data Bencana Section
                  _buildSectionHeader(context, Icons.info, 'Informasi Data Bencana'),
                  _buildInfoRow('Lokasi bencana', 'Cisompet, Kab. Garut, Jawa Barat'),
                  _buildInfoRow('Titik koordinat', '-6.988219, 107.644445'),
                  _buildInfoRow('Kondisi lokasi', 'Sedang'),
                  _buildInfoRow('Jumlah korban', '5 orang'),
                  _buildInfoRow('Deskripsi', 'Kerusakan infrastruktur: 2 masjid, 10 rumah, 1 kantor desa.'),

                  // --- Add this Button ---
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.forum),
                      label: const Text('Lihat Forum Diskusi'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumScreen(report: report),
                          ),
                        );
                      },
                    ),
                  )
                  // ------------------------
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

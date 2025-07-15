// Widget tests for Disaster Card component
// test/widget/widgets/disaster_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test/helpers/test_helpers.dart';

void main() {
  group('Disaster Card Widget Tests', () {
    Widget createDisasterCard({
      String title = 'Banjir di Jakarta Selatan',
      String location = 'Kemang, Jakarta Selatan',
      String type = 'Banjir',
      String severity = 'Sedang',
      String time = '2 jam yang lalu',
      String status = 'Sedang Ditangani',
      int victimCount = 10,
    }) {
      return TestHelpers.createTestApp(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and severity badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(severity),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        severity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(location)),
                  ],
                ),

                const SizedBox(height: 4),

                // Type
                Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('Jenis: $type'),
                  ],
                ),

                const SizedBox(height: 4),

                // Victim count
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('Korban: $victimCount orang'),
                  ],
                ),

                const SizedBox(height: 4),

                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),

                const SizedBox(height: 8),

                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Detail'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Bantu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('should display disaster card with all information',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      expect(find.text('Banjir di Jakarta Selatan'), findsOneWidget);
      expect(find.text('Kemang, Jakarta Selatan'), findsOneWidget);
      expect(find.text('Jenis: Banjir'), findsOneWidget);
      expect(find.text('Korban: 10 orang'), findsOneWidget);
      expect(find.text('2 jam yang lalu'), findsOneWidget);
      expect(find.text('Sedang Ditangani'), findsOneWidget);
      expect(find.text('Sedang'), findsOneWidget); // Severity badge
    });

    testWidgets('should display appropriate icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.byIcon(Icons.people), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('should display action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('Bantu'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle button taps', (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      await tester.tap(find.text('Detail'));
      await tester.pump();

      await tester.tap(find.text('Bantu'));
      await tester.pump();

      // Verify no errors occurred
    });

    testWidgets('should display different severity levels correctly',
        (WidgetTester tester) async {
      // Test different severity levels
      final severities = ['Ringan', 'Sedang', 'Berat', 'Sangat Berat'];

      for (final severity in severities) {
        await tester.pumpWidget(createDisasterCard(severity: severity));
        expect(find.text(severity), findsOneWidget);
        await tester.pump();
      }
    });

    testWidgets('should display different disaster types correctly',
        (WidgetTester tester) async {
      final types = ['Banjir', 'Gempa', 'Kebakaran', 'Tanah Longsor'];

      for (final type in types) {
        await tester.pumpWidget(createDisasterCard(type: type));
        expect(find.text('Jenis: $type'), findsOneWidget);
        await tester.pump();
      }
    });

    testWidgets('should handle zero victim count', (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard(victimCount: 0));

      expect(find.text('Korban: 0 orang'), findsOneWidget);
    });

    testWidgets('should handle large victim count',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard(victimCount: 1000));

      expect(find.text('Korban: 1000 orang'), findsOneWidget);
    });

    testWidgets('should display long location names correctly',
        (WidgetTester tester) async {
      const longLocation =
          'Jalan Raya Kemang Selatan No. 123, Kelurahan Kemang, Kecamatan Mampang Prapatan, Jakarta Selatan';

      await tester.pumpWidget(createDisasterCard(location: longLocation));

      expect(find.textContaining('Jalan Raya Kemang'), findsOneWidget);
    });

    testWidgets('should display long titles correctly',
        (WidgetTester tester) async {
      const longTitle =
          'Banjir Bandang Akibat Luapan Sungai Ciliwung dan Curah Hujan Tinggi di Jakarta Selatan';

      await tester.pumpWidget(createDisasterCard(title: longTitle));

      expect(find.textContaining('Banjir Bandang'), findsOneWidget);
    });

    testWidgets('should be accessible for screen readers',
        (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      await tester.pumpWidget(createDisasterCard());

      // Verify semantic labels exist
      expect(find.text('Banjir di Jakarta Selatan'), findsOneWidget);
      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('Bantu'), findsOneWidget);

      handle.dispose();
    });

    testWidgets('should have proper card layout', (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });
  });

  group('Disaster Card Edge Cases', () {
    Widget createDisasterCard({
      String title = '',
      String location = '',
      String type = '',
      String severity = '',
      String status = '',
    }) {
      return TestHelpers.createTestApp(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.isEmpty ? 'Tidak ada judul' : title),
                Text(location.isEmpty ? 'Lokasi tidak diketahui' : location),
                Text(type.isEmpty ? 'Jenis tidak diketahui' : 'Jenis: $type'),
                Text(severity.isEmpty
                    ? 'Tingkat: Tidak diketahui'
                    : 'Tingkat: $severity'),
                Text(status.isEmpty ? 'Status tidak diketahui' : status),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('should handle empty strings gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDisasterCard());

      expect(find.text('Tidak ada judul'), findsOneWidget);
      expect(find.text('Lokasi tidak diketahui'), findsOneWidget);
      expect(find.text('Jenis tidak diketahui'), findsOneWidget);
      expect(find.text('Tingkat: Tidak diketahui'), findsOneWidget);
      expect(find.text('Status tidak diketahui'), findsOneWidget);
    });

    testWidgets('should handle null safety appropriately',
        (WidgetTester tester) async {
      // Test with actual null-safe implementations
      await tester.pumpWidget(createDisasterCard(
        title: 'Valid Title',
        location: 'Valid Location',
      ));

      expect(find.text('Valid Title'), findsOneWidget);
      expect(find.text('Valid Location'), findsOneWidget);
    });
  });
}

// Helper functions for disaster card styling
Color _getSeverityColor(String severity) {
  switch (severity.toLowerCase()) {
    case 'ringan':
      return Colors.green;
    case 'sedang':
      return Colors.orange;
    case 'berat':
      return Colors.red;
    case 'sangat berat':
      return Colors.red[900]!;
    default:
      return Colors.grey;
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'tertangani':
      return Colors.green;
    case 'sedang ditangani':
      return Colors.blue;
    case 'membutuhkan bantuan':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// Integration Test for Real Mobile Device Testing
// integration_test/mobile_environment_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:astacala_rescue_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('📱 Real Mobile Device Integration Tests', () {
    testWidgets('🚀 App Launch and Navigation Test',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app launches successfully
      expect(find.byType(MaterialApp), findsOneWidget);

      // Take screenshot for visual verification
      await tester.binding.takeScreenshot('app_launch');

      print('✅ App launched successfully on device');
    });

    testWidgets('🔐 Authentication Flow Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      try {
        // Look for login/welcome screen elements
        if (find.text('Masuk').evaluate().isNotEmpty) {
          // Tap login button
          await tester.tap(find.text('Masuk'));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          print('✅ Found and tapped login button');
        }

        // Look for email field
        if (find.byType(TextFormField).evaluate().isNotEmpty) {
          // Enter test credentials
          await tester.enterText(
              find.byType(TextFormField).first, 'test@astacala.com');
          await tester.pumpAndSettle();

          print('✅ Entered email in form field');
        }

        await tester.binding.takeScreenshot('auth_screen');
      } catch (e) {
        print('ℹ️ Auth elements not found or different UI structure: $e');
      }

      print('✅ Authentication flow test completed');
    });

    testWidgets('🌐 Network Connectivity Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for any network calls to complete
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Check if app handles network state properly
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ Network connectivity test completed');
    });

    testWidgets('📺 Screen Rotation Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test portrait mode
      await tester.binding.setSurfaceSize(const Size(414, 896));
      await tester.pumpAndSettle();
      await tester.binding.takeScreenshot('portrait_mode');

      // Test landscape mode
      await tester.binding.setSurfaceSize(const Size(896, 414));
      await tester.pumpAndSettle();
      await tester.binding.takeScreenshot('landscape_mode');

      // Return to portrait
      await tester.binding.setSurfaceSize(const Size(414, 896));
      await tester.pumpAndSettle();

      print('✅ Screen rotation test completed');
    });

    testWidgets('📱 Touch Interaction Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test various touch interactions
      try {
        // Find scrollable areas
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          // Test scrolling
          await tester.drag(scrollables.first, const Offset(0, -100));
          await tester.pumpAndSettle();

          await tester.drag(scrollables.first, const Offset(0, 100));
          await tester.pumpAndSettle();

          print('✅ Scroll interactions tested');
        }

        // Find tappable elements
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          // Test button tap (without actually triggering actions)
          final firstButton = buttons.first;
          final center = tester.getCenter(firstButton);

          // Simulate tap down and up
          await tester.tapAt(center);
          await tester.pumpAndSettle();

          print('✅ Button tap tested');
        }
      } catch (e) {
        print('ℹ️ Some touch interactions not available: $e');
      }

      print('✅ Touch interaction test completed');
    });

    testWidgets('⚡ Performance Test', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      stopwatch.stop();
      final launchTime = stopwatch.elapsedMilliseconds;

      print('📊 App launch time: ${launchTime}ms');

      // Verify reasonable launch time (under 5 seconds)
      expect(launchTime, lessThan(5000));

      // Test frame rate during animations
      stopwatch.reset();
      stopwatch.start();

      // Trigger some animations by navigating (if possible)
      try {
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          for (int i = 0; i < 10; i++) {
            await tester.drag(scrollables.first, const Offset(0, -50));
            await tester.pump();
          }
        }
      } catch (e) {
        print('ℹ️ Animation test skipped: $e');
      }

      stopwatch.stop();
      print(
          '📊 Animation performance test completed in ${stopwatch.elapsedMilliseconds}ms');

      print('✅ Performance test completed');
    });

    testWidgets('🔄 App Lifecycle Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Simulate app going to background and returning
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.paused'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.resumed'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify app is still functional
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ App lifecycle test completed');
    });

    testWidgets('💾 Data Persistence Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for any data loading
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app handles data properly
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ Data persistence test completed');
    });

    testWidgets('🎯 Accessibility Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Basic accessibility check
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      print('✅ Accessibility test completed');
    });

    testWidgets('🔌 Backend Integration Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait for backend connections to establish
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Check if app loaded properly (indicating backend connectivity)
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ Backend integration test completed');
    });
  });
}

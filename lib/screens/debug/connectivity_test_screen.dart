// lib/screens/debug/connectivity_test_screen.dart
import 'package:flutter/material.dart';
import '../../utils/connectivity_helper.dart';
import '../../services/api_service.dart';

class ConnectivityTestScreen extends StatefulWidget {
  const ConnectivityTestScreen({Key? key}) : super(key: key);

  @override
  State<ConnectivityTestScreen> createState() => _ConnectivityTestScreenState();
}

class _ConnectivityTestScreenState extends State<ConnectivityTestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _testResult;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runConnectivityTest();
  }

  Future<void> _runConnectivityTest() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _testResult = null;
    });

    try {
      final result = await ConnectivityHelper.checkBackendConnectivity();
      setState(() {
        _testResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.login(
        email: 'test@astacala.com',
        password: 'password123',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final friendlyError =
            ConnectivityHelper.getUserFriendlyError(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Login failed: $friendlyError'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connectivity Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'API Configuration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Base URL: ${ApiService.baseUrl}'),
                    Text(
                        'Platform: ${_testResult?['platform'] ?? 'Detecting...'}'),
                    Text('Timestamp: ${_testResult?['timestamp'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _testResult?['connected'] == true
                              ? Icons.check_circle
                              : Icons.error,
                          color: _testResult?['connected'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Connection Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text('Testing connection...'),
                        ],
                      )
                    else if (_testResult != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _testResult!['connected']
                                ? '✅ Backend is accessible!'
                                : '❌ Cannot connect to backend',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _testResult!['connected']
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          if (_testResult!['error'] != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${ConnectivityHelper.getUserFriendlyError(_testResult!['error'])}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          if (_testResult!['response'] != null) ...[
                            const SizedBox(height: 8),
                            Text('Response: ${_testResult!['response']}'),
                          ],
                        ],
                      )
                    else if (_error != null)
                      Text(
                        'Test Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _runConnectivityTest,
              child: const Text('🔄 Retry Connection Test'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('🔐 Test Login'),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Troubleshooting',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('1. Make sure Laravel server is running:'),
                    Text('   php artisan serve --host=0.0.0.0 --port=8000'),
                    SizedBox(height: 4),
                    Text(
                        '2. Test manually: curl http://localhost:8000/api/health'),
                    SizedBox(height: 4),
                    Text('3. For Android emulator: Uses 10.0.2.2:8000'),
                    Text('4. For web/iOS: Uses localhost:8000'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

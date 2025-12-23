import 'package:flutter/material.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Firebase Connection Test Widget
/// 
/// This widget tests the Firebase connection and displays the status
class FirebaseConnectionTest extends StatefulWidget {
  const FirebaseConnectionTest({super.key});

  @override
  State<FirebaseConnectionTest> createState() => _FirebaseConnectionTestState();
}

class _FirebaseConnectionTestState extends State<FirebaseConnectionTest> {
  bool _isLoading = true;
  bool _isConnected = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Try to access Firestore
      final firestore = FirestoreService.instance.firestore;
      
      // Try to read from a test collection (this will verify connection)
      await firestore.collection('_connection_test').limit(1).get();

      setState(() {
        _isConnected = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Test'),
      ),
      body: Center(
        child: _isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Testing Firebase connection...'),
                ],
              )
            : _isConnected
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Firebase Connected Successfully!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Firestore is ready to use.'),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Firebase Connection Failed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _testConnection,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
      ),
    );
  }
}

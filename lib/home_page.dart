import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('screen_record_channel');
  String _status = 'Unknown';
  Future<void> _toggleScreenRecordPermission() async {
    try {
      final bool result = await platform.invokeMethod('toggleScreenRecording');
      _status =
          result ? 'Screen Recording ALLOWED' : 'Screen Recording BLOCKED';
      await _getCurrentStatus(); // fix state bug
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to toggle screen recording: ${e.message}";
      });
    }
  }

  Future<void> _getCurrentStatus() async {
    try {
      final bool result = await platform.invokeMethod(
        'isScreenRecordingAllowed',
      );
      setState(() {
        _status =
            result ? 'Screen Recording ALLOWED' : 'Screen Recording BLOCKED';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to get status: ${e.message}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Recording Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _toggleScreenRecordPermission();
              },
              child: const Text('Toggle Screen Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

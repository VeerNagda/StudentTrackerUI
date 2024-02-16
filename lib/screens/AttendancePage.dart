import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'TakePictureScreen.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedEvent;
  String? selectedVenue;
  late List<CameraDescription> cameras;

  List<String> availableEvents = ['Event 1', 'Event 2', 'Event 3'];
  List<String> availableVenues = ['Venue A', 'Venue B', 'Venue C'];

  late String text = "click";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown('Event Name', availableEvents, selectedEvent,
                (String? value) {
              setState(() {
                selectedEvent = value;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Venue', availableVenues, selectedVenue,
                (String? value) {
              setState(() {
                selectedVenue = value;
              });
            }),
            const SizedBox(height: 16),
            _buildClickPhotoButton(context),
            _buildClassService(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      items: items
          .map((item) =>
              DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildClickPhotoButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Click Photo'),
      onPressed: () async {
        cameras = await availableCameras();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(camera: cameras.first)),
        );
      },
    );
  }

  Widget _buildClassService(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('ForeGround'),
          onPressed: () async {
            FlutterBackgroundService().invoke('setAsForeground');
          },
        ),
        ElevatedButton(
          child: const Text('BackGround'),
          onPressed: () async {
            FlutterBackgroundService().invoke('setAsBackground');
          },
        ),
        ElevatedButton(
          onPressed: () async {
            final service = FlutterBackgroundService();
            bool isRunning = await service.isRunning();
            if (isRunning) {
              service.invoke("stopService");
            } else {
              service.startService();
            }
            if (!isRunning) {
              text = "Stop Service";
            } else {
              text = "Start service";
            }
            setState(() {});
          },
          child: Text(text),
        ),
      ],
    );
  }
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(
    MaterialApp(
      home: AttendancePage(cameras: cameras),
    ),
  );
}
*/

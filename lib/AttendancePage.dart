import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'CameraPage.dart';

class AttendancePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AttendancePage({Key? key, required this.cameras}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedEvent;
  String? selectedVenue;

  List<String> availableEvents = ['Event 1', 'Event 2', 'Event 3'];
  List<String> availableVenues = ['Venue A', 'Venue B', 'Venue C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown('Event Name', availableEvents, selectedEvent, (String? value) {
              setState(() {
                selectedEvent = value;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Venue', availableVenues, selectedVenue, (String? value) {
              setState(() {
                selectedVenue = value;
              });
            }),
            const SizedBox(height: 16),
            _buildClickPhotoButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildClickPhotoButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraPage(camera: widget.cameras.first)),
        );
      },
      child: const Text('Click Photo'),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(
    MaterialApp(
      home: AttendancePage(cameras: cameras),
    ),
  );
}

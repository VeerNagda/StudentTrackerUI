
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/shared_service.dart';


class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedEvent;

  List<String> availableEvents = ['Event 1', 'Event 2', 'Event 3'];

  late String text = "click";

  getAvailableEvents() async {
    String availableEvent = await APIService.doGet(path: "/user/event/events-today/${SharedService.sapId}");
    print(availableEvent);
  }

  @override
  void initState(){
    super.initState();
    getAvailableEvents();
  }

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
        context.pushNamed('verify-user');
      },
    );
  }

  Widget _buildClassService(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              final service = FlutterBackgroundService();
              Map<String, dynamic> data = {
                "sap": SharedService.sapId,
                "event_id": selectedEvent,
              };
              service.invoke("setData", data);
            },
            child: Text(text)),
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

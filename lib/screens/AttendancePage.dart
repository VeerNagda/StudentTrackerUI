import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/event/current_day_event_response_model.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/shared_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedEvent;
  bool serviceRunning = false;

  //List<String> availableEvents = ['Event 1', 'Event 2', 'Event 3'];
  Map<String, String> eventsMap = {};
  late CurrentDayEventResponseModel currentDayEventResponseModel;

  getAvailableEvents() async {
    currentDayEventResponseModel = currentDayEventJson(await APIService.doGet(
        path: "/user/event/events-today/${SharedService.sapId}"));

    currentDayEventResponseModel.events?.forEach((event) {
      eventsMap[event.ID!] = event.name!;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAvailableEvents();
    _checkServiceStatus();
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
            _buildDropdown('Event Name', eventsMap, selectedEvent,
                    (String? value) {
                  setState(() {
                    selectedEvent = value;
                  });
                }),
            const SizedBox(height: 16),
            _buildClickPhotoButton(context),
            ElevatedButton(
                onPressed: serviceRunning
                    ? () =>
                {
                  FlutterBackgroundService().invoke("stopService"),
                  serviceRunning = false,
                  setState(() {}),
                }:null,
                child: const Text("Stop Service"))
          ],
        ),
      ),
    );
  }

  _checkServiceStatus() async {
    serviceRunning = await FlutterBackgroundService().isRunning();
    setState(() {});
  }

  Widget _buildDropdown(String label, Map<String, String> items,
      String? selectedValue, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      items: eventsMap.entries.map((MapEntry<String, String> entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildClickPhotoButton(BuildContext context) {
    return ElevatedButton(
      onPressed: selectedEvent != null && selectedEvent!.isNotEmpty
          ? () async {
        SharedService.eventId = selectedEvent!;
        SharedService.eventEndTime = findEndTimeByEventId(
            currentDayEventResponseModel, selectedEvent!)!;
        SharedService.prefs.setString(
            "eventEndTime", SharedService.eventEndTime.toString());
        SharedService.prefs.setString("eventId", SharedService.eventId);
        context.pushNamed('verify-user');
      }
          : null,
      child: const Text('Click Photo'),
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

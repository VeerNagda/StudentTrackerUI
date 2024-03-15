import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/event/event_ended_model.dart';
import 'package:ui/services/api_service.dart';

class ReportAttendance extends StatefulWidget {
  const ReportAttendance({Key? key}) : super(key: key);

  @override
  _ReportAttendanceState createState() => _ReportAttendanceState();
}

class _ReportAttendanceState extends State<ReportAttendance> {
  late List<EventsEndedModel> events = [];
  late Map<int, bool> userSelectionMap;

  @override
  void initState() {
    super.initState();
    _fetchAllEventsEnded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Event ID',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Event Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Event Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Download',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: events.map((event) {
              return DataRow(cells: [
                DataCell(Text(event.iD)),
                DataCell(Text(event.name)),
                DataCell(Text(event.endDate.toString())),
                DataCell(download(event)),
              ]);
            }).toList()),
      ),
    );
  }

  void _fetchAllEventsEnded() {
    APIService.doGet(path: "/admin/attendance/all-ended-events").then(
      (value) {
        if (value != "") {
          setState(() {
            events = jsonDecode(value)
                .map<EventsEndedModel>(
                    (item) => EventsEndedModel.fromJson(item))
                .toList();
          });
        }
      },
    );
  }

  Widget download(EventsEndedModel event) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () {
        _showConfirmationDialog(context, event);
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, EventsEndedModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download Confirmation"),
          content: const Text("Are you sure you want to download this file?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _downloadFile(event);
                context.pop();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  /*void downloadFile(BuildContext context) async {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Add sample data to the Excel sheet
    sheet.appendRow([]);

    // Add sample event data
    sheet.appendRow([]);

    final List<int>? bytes = excel.encode();

    final Directory? directory = await getExternalStorageDirectory();
    final String path = '${directory?.path}/Attendance_Report.xlsx';
    final File file = File(path);

    // Write the bytes to the file
    await file.writeAsBytes(bytes!);

    // Show a message to the user
    final scaffoldContext = ScaffoldMessenger.of(context);
    scaffoldContext.showSnackBar(
      SnackBar(
        content: Text('File downloaded to $path'),
      ),
    );
  }*/

  _downloadFile(EventsEndedModel event) async {
    final externalPath = await getExternalStorageDirectory();

    String path;
    APIService.doGetCSV(
            path: "/admin/attendance/generate-attendance", param: event.iD)
        .then(
      (value) async => {
        if (value != null)
          {
            path = 'your_file_name.extension',
            // Specify the file name and extension

            saveAndOpenUint8List(value, path)
          }
      },
    );
  }

  Future<void> openFile(String filePath) async {
    // Launch the file using the default platform application
    if (await canLaunch(filePath)) {
      await launch(filePath);
    } else {
      throw 'Could not launch $filePath';
    }
  }

// Function to save Uint8List data to a file and open it
  Future<void> saveAndOpenUint8List(Uint8List data, String fileName) async {
    // Get the temporary directory using path_provider package
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Create a File object with a temporary file path
    File tempFile = File('$tempPath/$fileName');

    // Write the bytes to the file
    await tempFile.writeAsBytes(data);

    // Open the file
    await openFile(tempFile.path);
  }
}

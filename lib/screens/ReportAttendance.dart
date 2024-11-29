import 'dart:convert';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/event/event_ended_model.dart';
import 'package:ui/services/api_service.dart';

class ReportAttendance extends StatefulWidget {
  const ReportAttendance({super.key});

  @override
  _ReportAttendanceState createState() => _ReportAttendanceState();
}

class _ReportAttendanceState extends State<ReportAttendance> {
  late List<EventsEndedModel> events = [];
  late Map<int, bool> userSelectionMap;
  late final LocalStorage storage;

  @override
  void initState() {
    super.initState();
    _fetchAllEventsEnded();
    storage = LocalStorage('UI');
  }

  @override
  Widget build(BuildContext context) {
    final _verticalScrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _verticalScrollController,
        child: SingleChildScrollView(
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
                DataColumn(
                    label: Text(
                  'Details',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ))
              ],
              rows: events.map((event) {
                return DataRow(cells: [
                  DataCell(Text(event.iD)),
                  DataCell(Text(event.name)),
                  DataCell(Text(event.endDate.toString())),
                  DataCell(download(event)),
                  DataCell(moreInfo(event)),
                ]);
              }).toList()),
        ),
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

  Widget moreInfo(EventsEndedModel event) {
    return IconButton(
        onPressed: () {
          _navigateToMoreInfoPage(context, event);
        },
        icon: const Icon(Icons.more_horiz));
  }

  void _navigateToMoreInfoPage(BuildContext context, EventsEndedModel event) {
    context
        .pushNamed('attendance-detail', queryParameters: {'eventID': event.iD});
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
    Directory? downloadsDir;
    String path;
    APIService.doGetCSV(
            path: "/admin/attendance/generate-attendance", param: event.iD)
        .then(
      (value) async => {
        if (value != null)
          {
            // Specify the file name and extension

            downloadsDir = await getApplicationDocumentsDirectory(),
            path = "${downloadsDir!.path}/attendance",
            await FileSaver.instance.saveAs(
              name: 'attendance.csv',
              bytes: value,
              filePath: path,
              mimeType: MimeType.csv,
              ext: 'csv',
            )
          }
      },
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/attendance.csv');
  }

  Future<String> _saveFile(Uint8List csvData) async {
    final Directory? downloadsDir;
    if (kIsWeb) {
      downloadsDir = await getDownloadsDirectory();

      String path = "${downloadsDir!.path}attendance";

      return await FileSaver.instance.saveFile(
        name: 'attendance.csv',
        bytes: csvData,
        filePath: path,
        mimeType: MimeType.csv,
      );
    }
    return "";
  }
}

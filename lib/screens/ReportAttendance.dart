import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportAttendance extends StatelessWidget {
  const ReportAttendance({Key? key});

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
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('123')),
                DataCell(Text('YOLO')),
                DataCell(Text('31st ')),
                DataCell(DownloadButton()),
              ],
            ),
            // Add more rows as needed
          ],
        ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () {
        _showConfirmationDialog(context);
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download Confirmation"),
          content: const Text("Are you sure you want to download this file?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _downloadFile(context);
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

  void _downloadFile(BuildContext context) async {
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
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportAttendance extends StatelessWidget {
  final List<ReportAttendance>? events;

  const ReportAttendance({super.key, this.events});

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
  const DownloadButton({super.key});

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
                // TODO Perform download action here
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
}

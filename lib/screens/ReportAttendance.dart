import 'package:flutter/material.dart';
// For formatting date

class ReportAttendance extends StatelessWidget {
  final List<ReportAttendance>? events; // Making events nullable

  const ReportAttendance({super.key, this.events}); // Making events nullable

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
                DataCell(Icon(Icons.download)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReportAttendance(),
  ));
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/models/event/DetailedEventAttendanceReport.dart';

import '../services/api_service.dart';

class DetailAttendaceReportState extends StatefulWidget {
  final String? eventID;

  const DetailAttendaceReportState({super.key, this.eventID});

  @override
  State<DetailAttendaceReportState> createState() =>
      _DetailAttendaceReportState();
}

class _DetailAttendaceReportState extends State<DetailAttendaceReportState> {
  late List<DetailedEventAttendanceReport> events = [];

  @override
  void initState() {
    super.initState();
    if (widget.eventID != null) {
      getEventDetails();
    }
  }

  void getEventDetails() {
    APIService.doGet(path: "/admin/attendance/event-detail-report", param: widget.eventID).then(
          (value) {
        if (value != "") {
          setState(() {
            events = jsonDecode(value)
                .map<DetailedEventAttendanceReport>(
                    (item) => DetailedEventAttendanceReport.fromJson(item))
                .toList();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _verticalScrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Report ${widget.eventID}"),
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
                    'SAP ID',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Entry Time',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Coordinate',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'System Decision',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ],
              rows: events.map((event) {
                return DataRow(cells: [
                  DataCell(Text(event.id)),
                  DataCell(Text(event.time.toString())),
                  DataCell(Text(event.coordinates.toString())),
                  DataCell(Text(event.systemDecision == 0 ? "False" : "True")),
                ]);
              }).toList()),
        ),
      ),
    );
  }
}

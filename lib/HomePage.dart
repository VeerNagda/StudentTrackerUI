import 'package:flutter/material.dart';
import 'AttendancePage.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(sapId: ''),
    ),
  );
}

class HomePage extends StatelessWidget {
  final String sapId;

  HomePage({Key? key, required this.sapId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User Details'),
              Tab(text: 'Attendance'),
            ],
          ),
          title: Text(sapId),
        ),
        body: TabBarView(
          children: [
            UserDetails(
              //have put random value for now
              sapId: '12345678910',
              firstName: 'Parinaz',
              lastName: 'Bharucha',
              className: 'BSC IT',
              rollNumber: 'A000',
            ),
            AttendancePage(cameras: [],),
          ],
        ),
      ),
    );
  }

  Widget UserDetails({
    required String sapId,
    required String firstName,
    required String lastName,
    required String className,
    required String rollNumber,
  }) {
    return Scaffold(
      appBar: AppBar(
        //this will by default remove the arrow we get
        automaticallyImplyLeading: false,
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('SAP ID', sapId),
            _buildDetail('First Name', firstName),
            _buildDetail('Last Name', lastName),
            _buildDetail('Class', className),
            _buildDetail('Roll Number', rollNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              //have put placeholder for now.
              value.isNotEmpty ? value : 'Placeholder',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

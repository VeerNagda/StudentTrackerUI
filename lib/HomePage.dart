import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage(sapId: '',));
}
class HomePage extends StatelessWidget {
  final String sapId;

  const HomePage({super.key, required this.sapId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Attendance'),
              Tab(text: 'History'),
            ],
          ),
          //have taken the sap id from the login page
          title: Text(sapId),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home content')),
            Center(child: Text('Attendance content')),
            Center(child: Text('History content')),
          ],
        ),
      ),
    );
  }
}
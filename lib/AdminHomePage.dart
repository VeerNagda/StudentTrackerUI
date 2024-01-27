import 'package:flutter/material.dart';
import 'package:ui/EventsPage.dart';
import 'package:ui/AdminHistory.dart';

void main() {
  runApp(const AdminHomePage(sapId: ''));
}

class AdminHomePage extends StatelessWidget {
  final String sapId;

  const AdminHomePage({super.key, required this.sapId});

  @override
  Widget build(BuildContext context) {
    //have use tab instead of side nav bar
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // icon next to sap id
          leading: IconButton(
            icon: const Icon(Icons.person), onPressed: () {  }, // Use the person icon for profile

          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Events'),
              Tab(text: 'History'),
            ],
          ),
          title: Text(sapId),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home content')),
            EventsPage(),
            AdminHistory(),
          ],
        ),
      ),
    );
  }
}

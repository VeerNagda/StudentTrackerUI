import 'package:flutter/material.dart';
import 'package:ui/EventsPage.dart';
import 'package:ui/AdminHistory.dart';

void main() {
  runApp(const AdminHomePage(sapId: ''));
}

class AdminHomePage extends StatelessWidget {
  final String sapId;

  const AdminHomePage({Key? key, required this.sapId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Events'),
              Tab(text: 'History'),
            ],
          ),
          title: Text('$sapId'),
        ),
        body: TabBarView(
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

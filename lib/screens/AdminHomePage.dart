import 'package:flutter/material.dart';
import 'AdminHistory.dart';

import 'EventsPage.dart';

void main() {
  runApp(const AdminHomePage());
}

class AdminHomePage extends StatelessWidget {

  const AdminHomePage({super.key});

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
          title: const Text("sapId"),
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

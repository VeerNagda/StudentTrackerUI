import 'package:flutter/material.dart';
import 'package:ui/screens/AddVenuePage.dart';
import 'package:ui/screens/VenuePage.dart';
import 'package:ui/screens/login_page.dart';

import 'EventsPage.dart';
import 'StudentGroup.dart';

void main() {
  runApp(const AdminHomePage());
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // have not used go router yet
                // TO DO VEER
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Venue'),
              Tab(text: 'Student Group'),
              Tab(text: 'Attendance'),
            ],
          ),
          title: const Text("sapId"),
        ),
        body: const TabBarView(
          children: [
            EventsPage(),
            VenuesPage(),
            StudentGroup(), //not created student group page yet
            VenuesPage(), // not created attendance page yet
          ],
        ),
      ),
    );
  }
}

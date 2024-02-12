import 'package:flutter/material.dart';
import 'package:ui/screens/AddVenuePage.dart';
import 'package:ui/screens/EventsPage.dart';
import 'package:ui/screens/login_page.dart';

void main() {
  runApp(const AdminHomePage());
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {}, // Handle profile button tap
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // have not used go router yet
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Venue'),
              Tab(text: 'Student Group'),
            ],
          ),
          title: const Text("sapId"),
        ),
        body: const TabBarView(
          children: [
            EventsPage(),
            AddVenuePage(),
            AddVenuePage(),
          ],
        ),
      ),
    );
  }
}

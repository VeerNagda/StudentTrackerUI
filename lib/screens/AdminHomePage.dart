import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/screens/VenuePage.dart';

import '../services/shared_service.dart';
import 'EventsPage.dart';
import 'UserGroup.dart';

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
                SharedService.prefs.remove("accessToken");
                SharedService.prefs.remove("role");
                SharedService.prefs.remove("sapId");
                SharedService.isAuth = false;
                context.goNamed("login");
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

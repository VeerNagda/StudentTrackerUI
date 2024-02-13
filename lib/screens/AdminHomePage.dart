import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/screens/AddVenuePage.dart';
import 'package:ui/screens/login_page.dart';
import 'package:ui/services/shared_service.dart';

import 'EventsPage.dart';

void main() {
  runApp(const AdminHomePage());
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

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

                SharedService.prefs.remove("accessToken");
                SharedService.prefs.remove("role");
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
            AddVenuePage(),
            AddVenuePage(), //not created student group page yet
            AddVenuePage(), // not created attendance page yet
          ],
        ),
      ),
    );
  }
}

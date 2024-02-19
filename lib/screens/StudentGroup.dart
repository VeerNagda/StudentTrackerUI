import 'package:flutter/material.dart';
import 'package:ui/screens/AddVenuePage.dart';
import 'package:ui/screens/VenuePage.dart';
import 'package:ui/screens/login_page.dart';
import 'EventsPage.dart';
import 'GroupPage.dart';
import 'StudentPage.dart';

class StudentGroup extends StatelessWidget {
  const StudentGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: 'Student'),
              Tab(text: 'Group'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StudentPage(),
            GroupPage(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'GroupPage.dart';
import 'CreateUserPage.dart';

class StudentGroup extends StatelessWidget {
  const StudentGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'New User'),
              Tab(text: 'Group'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CreateUserPage(),
            GroupPage(),
          ],
        ),
      ),
    );
  }
}

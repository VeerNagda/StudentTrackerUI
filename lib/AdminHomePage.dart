import 'package:flutter/material.dart';

void main() {
  runApp(const AdminHomePage(sapId: '',));
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
          //have taken the sap id from the login page
          title: Text('$sapId'),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home content')),
            Center(child: Text('Events content')),
            Center(child: Text('History content')),
          ],
        ),
      ),
    );
  }
}
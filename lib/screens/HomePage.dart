import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/user/user_response_model.dart';
import 'package:ui/services/api_service.dart';
import '../services/shared_service.dart';

import 'AttendancePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserResponseModel? user;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String sapId = "";
  String fName = "";
  String lName = "";
  String roll = "";
  String phone = "";
  String email = "";

  _fetchData() {
    APIService.doGet(path: "/user/single-user", param: SharedService.sapId)
        .then((value) => {
              user = UserResponseModel.fromJson(jsonDecode(value)),
              SharedService.setUserDetails(user!),
              sapId = (SharedService.prefs.getString("sapId")) ?? "",
              fName = user!.fName,
              lName = user!.lName,
              email = user!.email,
              phone = user!.phone,
              roll = user!.rollNo,
              setState(() {})
            });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                SharedService.prefs.remove("sapId");
                FlutterBackgroundService().isRunning().then(
                      (value) => {
                        if (value)
                          {FlutterBackgroundService().invoke("stopService")}
                      },
                    );
                SharedService.isAuth = false;
                context.goNamed("login");
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User Profile'),
              Tab(text: 'Attendance'),
            ],
          ),
          title: const Text("sapId"),
        ),
        body: TabBarView(
          children: [
            UserDetails(),
            const AttendancePage(),
          ],
        ),
      ),
    );
  }

  Widget UserDetails() {
    return Scaffold(
      appBar: AppBar(
        //this will by default remove the arrow we get
        automaticallyImplyLeading: false,
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('SAP ID', sapId),
            _buildDetail('First Name', fName),
            _buildDetail('Last Name', lName),
            _buildDetail('Roll Number', roll),
            _buildDetail('Phone', phone),
            _buildDetail('Email', email),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              //have put placeholder for now.
              value.isNotEmpty ? value : 'Placeholder',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

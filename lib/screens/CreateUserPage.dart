import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'AddSingleUser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ui/models/user/user_response_model.dart';
import 'package:ui/services/api_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late List<UserResponseModel> users = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Wrap the Column widget with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Users:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('SAP ID')),
                      DataColumn(label: Text('First Name')),
                      DataColumn(label: Text('Last Name')),
                      DataColumn(label: Text('Roll No')),
                      DataColumn(label: Text('Phone No')),
                      DataColumn(label: Text('Email ID')),
                      DataColumn(label: Text('Role')),
                    ],
                    rows: users.map((user) {
                      return DataRow(cells: [
                        DataCell(Text(user.iD)),
                        DataCell(Text(user.fName)),
                        DataCell(Text(user.lName)),
                        DataCell(Text(user.rollNo)),
                        DataCell(Text(user.phone)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.role.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Add Single User'),
                    onTap: () {
                      Navigator.pop(context);
                      context.goNamed('single-user');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_alt),
                    title: const Text('Add Bulk Users'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddBulkUsersDialog(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }



//pop up wala part for bulk user


  void _showAddBulkUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add CSV File'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a CSV file to add users in bulk.'),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv'],
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;
                    print(file.name);
                    print(file.bytes);
                    print(file.size);
                    print(file.extension);
                    print(file.path);
                  } else {
                  }
                },
                child: const Text('Select CSV File'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO Handle the CSV file and add users
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _fetchAllUsers() {
    APIService.doGet(path: "/admin/user/all-users").then(
      (value) => {
        if (value != "")
          {
            setState(
              () {
                users = jsonDecode(value)
                    .map<UserResponseModel>(
                        (item) => UserResponseModel.fromJson(item))
                    .toList();
              },
            )
          }
      },
    );
  }
}

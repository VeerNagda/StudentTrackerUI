import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ui/models/user/user_response_model.dart';
import 'package:ui/services/api_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late List<UserResponseModel> users = [];
  late Map<String, bool> userSelectionMap = {};
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _buildAppBarActions(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                            value: selectAll,
                            onChanged: (bool? value) {
                              setState(() {
                                selectAll = value ?? false;
                                userSelectionMap.forEach((key, _) {
                                  userSelectionMap[key] = selectAll;
                                });
                              });
                            },
                          ),
                          const Text('Select All'),
                        ],
                      ),
                    ),
                    const DataColumn(label: Text('SAP ID')),
                    const DataColumn(label: Text('First Name')),
                    const DataColumn(label: Text('Last Name')),
                    const DataColumn(label: Text('Roll No')),
                    const DataColumn(label: Text('Phone No')),
                    const DataColumn(label: Text('Email ID')),
                    const DataColumn(label: Text('Role')),
                    const DataColumn(label: Text('Edit/Delete')),
                  ],
                  rows: users.map((user) {
                    return DataRow(cells: [
                      DataCell(Checkbox(
                        value: userSelectionMap[user.iD] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            userSelectionMap[user.iD] = value ?? false;
                          });
                        },
                      )),
                      DataCell(Text(user.iD)),
                      DataCell(Text(user.fName)),
                      DataCell(Text(user.lName)),
                      DataCell(Text(user.rollNo)),
                      DataCell(Text(user.phone)),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.role.toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editUser(user);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(user);
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
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
                      context.goNamed('single-user');
                      context.pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_alt),
                    title: const Text('Add Bulk Users'),
                    onTap: () {
                      context.pop();
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


// Delete icon for
  List<Widget> _buildAppBarActions() {
    if (selectAll) {
      return [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteSelectedUsers();
          },
        ),
      ];
    } else {
      return [];
    }
  }

  void _deleteSelectedUsers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected Users'),
          content: const Text('Are you sure you want to delete all the selected users?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeSelectedUsers();
                context.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  void _removeSelectedUsers() {
    List<String> selectedUserIDs = userSelectionMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();


    setState(() {
      users.removeWhere((user) => selectedUserIDs.contains(user.iD));
      selectedUserIDs.forEach((id) => userSelectionMap.remove(id));
    });

    selectedUserIDs.forEach((id) {
      //TODO API
      /*
      APIService.doDeleteUser(id).then((success) {
        if (success) {
          // Show a snackbar or toast to indicate successful deletion
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Selected users deleted successfully.'),
          ));
        } else {
          // Show a snackbar or toast to indicate failure
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete selected users.'),
          ));
        }
      }); */
    });
  }


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
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
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
                  } else {}
                },
                child: const Text('Select CSV File'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO Handle the CSV file and add users
                context.pop();
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
                userSelectionMap = {for (var user in users) user.iD: false};
              },
            )
          }
      },
    );
  }

  //TODO edit functionality
  void _editUser(UserResponseModel user) {
    context.goNamed('single-user');
  }

  void _deleteUser(UserResponseModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _removeUser(user);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _removeUser(UserResponseModel user) {
    // Removing the user from the list
    setState(() {
      users.remove(user);
      userSelectionMap.remove(user.iD);
    });


    //TODO check
    /* APIService.doDeleteUser(user.iD).then((success) {
      if (success) {
        // Show a snack-bar or toast to indicate successful deletion
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User deleted successfully.'),
        ));
      } else {
        // Show a snack-bar or toast to indicate failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete user.'),
        ));
      }
    }); */

  }

}

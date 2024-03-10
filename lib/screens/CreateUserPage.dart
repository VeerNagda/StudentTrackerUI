import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ui/models/user/user_response_model.dart';
import 'package:ui/services/api_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key});

  @override
  CreateUserPageState createState() => CreateUserPageState();
}

class CreateUserPageState extends State<CreateUserPage> {
  late List<UserResponseModel> users = [];
  late Map<String, bool> userSelectionMap = {};
  int itemsPerPage = 25;
  int totalItems = 100;
  bool selectAll = false;
  int page = 1;
  bool isSearching = false;
  String searchQuery = '';

  bool sortAscending = true;
  int sortColumnIndex = 0;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columns: [

                        DataColumn(
                          label: Row(
                            children: [
                              Text('SAP ID'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('iD');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('First Name'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('fName');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Last Name'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('lName');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Roll No'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('rollNo');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Phone No'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('phone');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Email ID'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('email');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Role'),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    sortColumnIndex = 1;
                                    sortAscending = !sortAscending;
                                    _sortUsersByColumn('role');
                                  });
                                },
                                child: Icon(
                                  sortColumnIndex == 1
                                      ? sortAscending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down
                                      : Icons.arrow_drop_down_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const DataColumn(label: Text('Edit')),
                      ],
                      //search functioning
                      rows: users
                          .where((user) =>
                      user.fName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          user.lName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          user.iD.toLowerCase().contains(searchQuery.toLowerCase()))
                          .skip((page - 1) * itemsPerPage)
                          .take(itemsPerPage)
                          .map((user) {
                        return DataRow(cells: [

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

                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Pagination(
                      totalPage: totalItems ~/ itemsPerPage,
                      onPageChange: (int page) {
                        setState(() {
                          this.page = page;
                        });
                        _fetchAllUsers();
                      },
                      currentPage: page,
                      paginateButtonStyles: PaginateButtonStyles(
                        backgroundColor: Colors.transparent,

                        textStyle: const TextStyle(
                          color: Colors.purple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      prevButtonStyles: PaginateSkipButton(
                        buttonBackgroundColor: Colors.transparent,
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.purple,
                        ),
                      ),
                      nextButtonStyles: PaginateSkipButton(
                        buttonBackgroundColor: Colors.transparent,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.purple,
                        ),
                      ),
                      show: 1,
                    )



                  ],
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
                      _showAddBulkUsersDialog();
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

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchQuery = '';
            }
          });
        },
      ),

      if (isSearching)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = '';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
    ];
  }


  //sorting
  void _sortUsersByColumn(String columnName) {
    switch (columnName) {
      case 'iD':
        if (sortAscending) {
          users.sort((a, b) => a.iD.compareTo(b.iD));
        } else {
          users.sort((a, b) => b.iD.compareTo(a.iD));
        }
        break;
      case 'fName':
        if (sortAscending) {
          users.sort((a, b) => a.fName.compareTo(b.fName));
        } else {
          users.sort((a, b) => b.fName.compareTo(a.fName));
        }
        break;
      case 'lName':
        if (sortAscending) {
          users.sort((a, b) => a.lName.compareTo(b.lName));
        } else {
          users.sort((a, b) => b.lName.compareTo(a.lName));
        }
        break;
      case 'rollNo':
        if (sortAscending) {
          users.sort((a, b) => a.rollNo.compareTo(b.rollNo));
        } else {
          users.sort((a, b) => b.rollNo.compareTo(a.rollNo));
        }
        break;
      case 'phone':
        if (sortAscending) {
          users.sort((a, b) => a.phone.compareTo(b.phone));
        } else {
          users.sort((a, b) => b.phone.compareTo(a.phone));
        }
        break;
      case 'email':
        if (sortAscending) {
          users.sort((a, b) => a.email.compareTo(b.email));
        } else {
          users.sort((a, b) => b.email.compareTo(a.email));
        }
        break;
      case 'role':
        if (sortAscending) {
          users.sort((a, b) => a.role.compareTo(b.role));
        } else {
          users.sort((a, b) => b.role.compareTo(a.role));
        }

    }
  }



  void _deleteSelectedUsers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected Users'),
          content:
          const Text('Are you sure you want to delete all the selected users?'),
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

  void _showAddBulkUsersDialog() {
    Uint8List? uploadFileData;
    String tip = 'Select CSV File';
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
                    setState(() {
                      tip = result.files.single.name;
                    });
                    if (kIsWeb) {
                      uploadFileData = result.files.single.bytes;
                    } else {
                      File? file = File(result.files.single.path!);
                      uploadFileData = file.readAsBytesSync();
                    }
                  } else {
                    // User canceled the picker
                  }
                },
                child: Text(tip),
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
                if (kIsWeb) {
                  _saveMultipleStudents(uploadFileData!);
                }
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
                userSelectionMap = {
                  for (var user in users) user.iD: false
                };
              },
            )
          }
      },
    );
  }

  Future<void> _saveMultipleStudents(Uint8List file) async {
    int response = await APIService.doMultipartCsvPost(
        path: "/admin/user/create-multiple-user",
        fileBytes: file,
        fileName: 'createUsers');
    if (response == 200 && mounted) {
      context.pop();
    } else {
      if (kDebugMode) {
        print(response);
      }
    }
  }

  void _editUser(UserResponseModel user) {
    context.pushNamed('single-user', queryParameters: {
      "sapId": user.iD,
    }).then((value) => {_fetchAllUsers()});
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Users'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Enter search query',
            ),
          ),
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
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}



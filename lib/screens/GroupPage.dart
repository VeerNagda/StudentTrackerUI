import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/StudentGroup/create_group_request_model.dart';
import 'package:ui/models/StudentGroup/group_list_response_model.dart';
import 'package:ui/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  late List<GroupListResponseModel> groups = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  void _fetchGroups() {
    APIService.doGet(path: "/admin/group/all-groups").then((value) {
      if (value != "") {
        setState(() {
          groups = jsonDecode(value)
              .map<GroupListResponseModel>(
                  (item) => GroupListResponseModel.fromJson(item))
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: groups.isEmpty
            ? const Center(
                child: Text(
                  'No groups yet. Tap the + button to add a group.',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            : ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Group ${groups[index].name}'),
                      subtitle: Text('Members: ${groups[index].numMembers}'),
                      onTap: () {
                        _navigateToGroupDetails(groups[index]);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () {
                              _navigateToAddStudents(groups[index]);
                            },
                            tooltip: 'Add Students',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditGroup(groups[index]);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmationDialog(groups[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddGroup();
        },
        tooltip: 'Add Group',
        child: const Icon(Icons.add),
      ),
    );
  }

  _navigateToAddGroup() async {
    TextEditingController groupIdController = TextEditingController();
    TextEditingController groupNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: groupIdController,
                decoration: const InputDecoration(labelText: 'Group ID'),
              ),
              TextField(
                controller: groupNameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
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
              onPressed: () async {
                CreateGroupRequestModel model = CreateGroupRequestModel(
                    groupId: groupIdController.text,
                    groupName: groupNameController.text);
                int response = await APIService.doPostInsert(
                    context: context,
                    data: model.toJson(),
                    path: "/admin/group/create-group");
                if (response == 201 && mounted) {
                  Navigator.pop(context);
                  _fetchGroups();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  _navigateToEditGroup(GroupListResponseModel group) async {
    TextEditingController groupIdController = TextEditingController();
    TextEditingController groupNameController = TextEditingController();

    groupIdController.text = group.iD;
    groupNameController.text = group.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: groupIdController,
                decoration: const InputDecoration(labelText: 'Group ID'),
                readOnly: true,
              ),
              TextField(
                controller: groupNameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
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
              onPressed: () async {
                _updateGroup(group, groupNameController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  _updateGroup(GroupListResponseModel group, String newGroupName) async {
    Map<String, dynamic> data = {"newName" : newGroupName};
    int response = await APIService.doPut(context: context, data: data, path: "/admin/group/update-group", param: group.iD);

    setState(() {
      _fetchGroups();
    });
    if(response == 200 && mounted){
      context.pop();
    }

  }

  //for students

  _navigateToAddStudents(GroupListResponseModel group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController sapIdController = TextEditingController();

        Uint8List? uploadFileData;
        int selectedValue = 0; // To track the selected option

        return AlertDialog(
          title: const Text('Add Students'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                          ),
                          const Text('Single'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                          ),
                          const Text('Multiple'),
                        ],
                      ),
                    ],
                  ),
                  if (selectedValue ==
                      0) // Show SAP ID input only if "Single Student" is selected
                    TextField(
                      controller: sapIdController,
                      decoration: const InputDecoration(labelText: 'SAP ID'),
                      keyboardType: TextInputType.number,
                    ),
                  if (selectedValue ==
                      1) // Show a button to select a CSV file only if "Multiple Students" is selected
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['csv'],
                        );
                        if (result != null) {
                          if(kIsWeb){
                            uploadFileData = result.files.single.bytes;
                          }
                          else{
                            File? file = File(result.files.single.path!);
                            uploadFileData = file.readAsBytesSync();
                          }
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Text('Select CSV File'),
                    ),
                ],
              );
            },
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
                if (selectedValue == 0) {
                  // Save single student with SAP ID
                  String sapId = sapIdController.text;
                  _saveSingleStudent(sapId, group);
                }
                if (selectedValue == 1) {
                  if(kIsWeb) {
                    _saveMultipleStudents(uploadFileData!, group);
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSingleStudent(
      String sapId, GroupListResponseModel group) async {
    Map<String, dynamic> data = {"group_id": group.iD, "user_id": sapId};
    int response = await APIService.doPostInsert(
        context: context, data: data, path: "/admin/group/assign-student");
    if (response == 201 && mounted) {
      context.pop();
    } else {
      if (kDebugMode) {
        print(response);
      }
    }
  }

  Future<void> _saveMultipleStudents(
      Uint8List file, GroupListResponseModel group) async {
    String groupId = group.iD;
    int response = await APIService.doMultipartCsvPost(
        path: "/admin/group/assign-multiple-user/$groupId", fileBytes: file, fileName: 'assign-multiple-user');
    if (response == 200 && mounted) {
      context.pop();
    } else {
      if (kDebugMode) {
        print(response);
      }
    }
  }

  _showDeleteConfirmationDialog(GroupListResponseModel group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: const Text('Are you sure you want to delete this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteGroup(group);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  _deleteGroup(GroupListResponseModel group) {
    String groupID = group.iD;

    APIService.doDelete(
        path: "/admin/group/delete-group", param: groupID).then((value) {
      if (value == 204) {
        setState(() {
          _fetchGroups();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Group $groupID deleted successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete group $groupID'),
        ));
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error deleting group: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete group $groupID'),
      ));
    });
  }

  _navigateToGroupDetails(GroupListResponseModel selectedGroup) {
    print('Selected Group Details:');
    print('Group Number: ${selectedGroup.iD}');
    print('Number of Members: ${selectedGroup.numMembers}');
  }

/*
  _saveGroup(GroupResponseModel group) {
    if (group.groupNumber == 0 || group.members.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please provide valid group information.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        int index =
            groups1.indexWhere((g) => g.groupNumber == group.groupNumber);
        if (index != -1) {
          groups1[index] = group;
        } else {
          groups1.add(group);
        }
      });

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
*/
}

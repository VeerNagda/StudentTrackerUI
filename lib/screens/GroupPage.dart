import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/StudentGroup/create_group_request_model.dart';
import 'package:ui/models/StudentGroup/group_list_response_model.dart';
import 'package:ui/models/StudentGroup/group_response_model.dart';
import 'package:ui/screens/AddGroup.dart';
import 'package:ui/services/api_service.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late List<GroupResponseModel> groups1 = [];
  late List<GroupListResponseModel> groups = [];



  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  void _fetchGroups() {


    APIService.doGet(path: "/admin/group/all-groups").then((value) => {
      if (value != "")
        {
          setState(() {
            groups = jsonDecode(value)
                .map<GroupListResponseModel>(
                    (item) => GroupListResponseModel.fromJson(item))
                .toList();
          }),
          print(groups)
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
                      subtitle:
                          Text('Members: ${groups[index].numMembers}'),
                      onTap: () {
                        _navigateToGroupDetails(groups1[index]);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
          title: Text('Add Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: groupIdController,
                decoration: InputDecoration(labelText: 'Group ID'),
              ),
              TextField(
                controller: groupNameController,
                decoration: InputDecoration(labelText: 'Group Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                CreateGroupRequestModel model = CreateGroupRequestModel(
                    groupId: groupIdController.text,
                    groupName: groupNameController.text);
                int response = await APIService.doPostInsert(
                    context: context,
                    data: model.toJson(),
                    path: "/admin/group/create-group");
                if(response == 201 && mounted) {
                  context.pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    _fetchGroups();
  }

  _navigateToEditGroup(GroupListResponseModel group) async {
    /*GroupListResponseModel? updatedGroup = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGroup(
          onSaveGroup: (GroupResponseModel updatedGroup) {
            return updatedGroup;
          },
          initialGroup: group,
        ),
      ),
    );

    if (updatedGroup != null) {
      setState(() {
        int index =
            groups1.indexWhere((g) => g.groupNumber == updatedGroup.groupNumber);
        if (index != -1) {
          groups1[index] = updatedGroup;
        }
      });
    }*/
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
        path: "/admin/delete-group",
        query: {"groupID": groupID.toString()}).then((value) {
      if (value == "Success") {
        setState(() {
          groups1.remove(group);
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
      print('Error deleting group: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete group $groupID'),
      ));
    });
  }

  _navigateToGroupDetails(GroupResponseModel selectedGroup) {
    print('Selected Group Details:');
    print('Group Number: ${selectedGroup.groupNumber}');
    print('Number of Members: ${selectedGroup.members.length}');
  }

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
}

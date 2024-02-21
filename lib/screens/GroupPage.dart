import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ui/models/StudentGroup/group_response_model.dart';
import 'package:ui/screens/AddGroup.dart';
import 'package:ui/services/api_service.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late List<GroupResponseModel> groups = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  void _fetchGroups() {
    APIService.doGet(path: "/admin/get-groups").then((value) {
      if (value != "") {
        setState(() {
          groups = (jsonDecode(value) as List)
              .map((item) => GroupResponseModel.fromJson(item))
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
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Group ${groups[index].groupNumber}'),
                subtitle: Text(
                    'Members: ${groups[index].members.length}'),
                onTap: () {
                  _navigateToGroupDetails(groups[index]);
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
              onPressed: () {
                GroupResponseModel newGroup = GroupResponseModel(
                  groupNumber: int.tryParse(groupIdController.text) ?? 1,
                  name: groupNameController.text,
                  members: [],
                );
                _saveGroup(newGroup);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    _fetchGroups();
  }

  _navigateToEditGroup(GroupResponseModel group) async {
    GroupResponseModel? updatedGroup = await Navigator.push(
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
        int index = groups.indexWhere((g) => g.groupNumber == updatedGroup.groupNumber);
        if (index != -1) {
          groups[index] = updatedGroup;
        }
      });
    }
  }

  _showDeleteConfirmationDialog(GroupResponseModel group) {
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

  _deleteGroup(GroupResponseModel group) {
    int groupNumber = group.groupNumber ?? 1;

    APIService.doDelete(path: "/admin/delete-group", query: {"groupNumber": groupNumber.toString()})
        .then((value) {
      if (value == "Success") {
        setState(() {
          groups.remove(group);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Group $groupNumber deleted successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete group $groupNumber'),
        ));
      }
    }).catchError((error) {

      print('Error deleting group: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete group $groupNumber'),
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
        int index = groups.indexWhere((g) => g.groupNumber == group.groupNumber);
        if (index != -1) {
          groups[index] = group;
        } else {
          groups.add(group);
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

import 'package:flutter/material.dart';
import 'package:ui/models/StudentGroup/group_response_model.dart';

class GroupResult {
  final GroupResponseModel? group;

  GroupResult({this.group});
}


class AddGroup extends StatefulWidget {
  final Function(GroupResponseModel) onSaveGroup;
  final GroupResponseModel? initialGroup;

  const AddGroup({Key? key, required this.onSaveGroup, this.initialGroup}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  late TextEditingController descriptionController;
  late List<String> studentNames;
  late GroupResponseModel group;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    studentNames = [];
    group = widget.initialGroup ?? GroupResponseModel(groupNumber: 0, members: [], description: '');
    studentNames.addAll(group.members);
    descriptionController.text = group.description;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _addStudent() {
    setState(() {
      studentNames.add('');
    });
  }

  void _removeStudent(int index) {
    setState(() {
      studentNames.removeAt(index);
    });
  }

  void _saveGroup() {
    GroupResponseModel newGroup = GroupResponseModel(
      groupNumber: group.groupNumber,
      members: studentNames,
      description: descriptionController.text,
    );

    widget.onSaveGroup(newGroup);
    Navigator.pop(context);
    Navigator.pop(context, GroupResult(group: newGroup));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            Text(
              'Students:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: studentNames.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: studentNames[index],
                        onChanged: (value) {
                          setState(() {
                            studentNames[index] = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Student ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        _removeStudent(index);
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add Student'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveGroup,
              child: const Text('Save Group'),
            ),
          ],
        ),
      ),
    );
  }
}

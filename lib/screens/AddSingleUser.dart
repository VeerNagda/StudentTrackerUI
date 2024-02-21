import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum UserRole { Admin, Student }

class AddSingleUserPage extends StatefulWidget {
  const AddSingleUserPage({Key? key});

  @override
  _AddSingleUserPageState createState() => _AddSingleUserPageState();
}

class _AddSingleUserPageState extends State<AddSingleUserPage> {
  TextEditingController sapIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Single User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: sapIdController,
              decoration: const InputDecoration(labelText: 'SAP ID'),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: rollNumberController,
              decoration: const InputDecoration(labelText: 'Roll Number'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<UserRole>(
              value: selectedRole,
              onChanged: (UserRole? value) {
                setState(() {
                  selectedRole = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Role',
                border: const OutlineInputBorder(),
              ),
              items: UserRole.values.map((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveUserData();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void saveUserData() {
    String sapId = sapIdController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String rollNumber = rollNumberController.text;
    int roleValue;

    //0 and 1 wala part
    if (selectedRole == UserRole.Admin) {
      roleValue = 0;
    } else {
      roleValue = 1;
    }

    print('SAP ID: $sapId');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Roll Number: $rollNumber');
    print('Role: $selectedRole');

    sapIdController.clear();
    firstNameController.clear();
    lastNameController.clear();
    rollNumberController.clear();

    Fluttertoast.showToast(
      msg: 'Successfully added',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white60,
      textColor: Colors.purple,
    );
  }

  @override
  void dispose() {
    sapIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    rollNumberController.dispose();
    super.dispose();
  }
}

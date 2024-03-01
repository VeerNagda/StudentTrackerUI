import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ui/services/api_service.dart';

enum UserRole { Admin, Student }

class AddSingleUserPage extends StatefulWidget {
  const AddSingleUserPage({super.key});

  @override
  _AddSingleUserPageState createState() => _AddSingleUserPageState();
}

class _AddSingleUserPageState extends State<AddSingleUserPage> {
  TextEditingController sapIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              keyboardType: TextInputType.number,
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
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Id'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone No.'),
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
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
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
    String email = emailController.text;
    String phone = phoneController.text;
    String rollNumber = rollNumberController.text;
    int roleValue;

    //0 and 1 wala part
    if (selectedRole == UserRole.Admin) {
      roleValue = 0;
    } else {
      roleValue = 1;
    }

    Map<String, dynamic> data = {
      "sapId": sapId,
      "firstName": firstName,
      "lastName": lastName,
      "rollNumber": rollNumber,
      "email": email,
      "phone": phone,
      "role": roleValue
    };
    print(jsonEncode(data));
    APIService.doPostInsert(
            context: context, data: data, path: "/admin/user/create-single-user")
        .then(
      (value) => {
        if (value == 201)
          {
            sapIdController.clear(),
            firstNameController.clear(),
            lastNameController.clear(),
            rollNumberController.clear(),
            phoneController.clear(),
            emailController.clear(),
          }
      },
    );
  }

  @override
  void dispose() {
    sapIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    rollNumberController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

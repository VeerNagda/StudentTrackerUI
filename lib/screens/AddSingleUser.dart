import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/user/user_response_model.dart';
import 'package:ui/services/api_service.dart';

enum UserRole { admin, student }

class AddSingleUserPage extends StatefulWidget {
  final String? sapId;

  const AddSingleUserPage({super.key, this.sapId});

  @override
  AddSingleUserPageState createState() => AddSingleUserPageState();
}

class AddSingleUserPageState extends State<AddSingleUserPage> {
  TextEditingController sapIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  UserRole? selectedRole;
  UserResponseModel? user;

  _getUserInfo() {
    APIService.doGet(path: "/admin/user/single-user", param: widget.sapId)
        .then((value) => {
              if (value != "")
                {
                  user = UserResponseModel.fromJson(jsonDecode(value)),
                  sapIdController.text = user!.iD,
                  firstNameController.text = user!.fName,
                  lastNameController.text = user!.lName,
                  emailController.text = user!.email,
                  phoneController.text = user!.phone,
                  rollNumberController.text = user!.rollNo,
                  if (user!.role == 0)
                    {
                      selectedRole = UserRole.admin,
                    }
                  else
                    {
                      selectedRole = UserRole.student,
                    },
                  setState(() {}),
                }
            });
  }

  @override
  void initState() {
    super.initState();
    if (widget.sapId != null) {
      _getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = user != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Single User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: sapIdController,
              decoration: const InputDecoration(labelText: 'SAP ID'),
              keyboardType: TextInputType.number,
              enabled: !isEditing,
              readOnly: isEditing,
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
                saveUserData(isEditing);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void saveUserData(bool isEditing) {
    String sapId = sapIdController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String rollNumber = rollNumberController.text;
    int? roleValue = selectedRole?.index;

    if (!isEditing) {
      Map<String, dynamic> data = {
        "sapId": sapId,
        "firstName": firstName,
        "lastName": lastName,
        "rollNumber": rollNumber,
        "email": email,
        "phone": phone,
        "role": roleValue
      };

      APIService.doPostInsert(
              context: context,
              data: data,
              path: "/admin/user/create-single-user")
          .then(
        (value) => {
          if (value == 201)
            {
              context.pop(),
            }
        },
      );
    }
    else {
      Map<String, dynamic> data = {
        "firstName": firstName,
        "lastName": lastName,
        "rollNumber": rollNumber,
        "email": email,
        "phone": phone,
        "role": roleValue
      };

      APIService.doPut(
          context: context,
          data: data,
          path: "/admin/user/update-user",
      param: sapId)
          .then(
            (value) => {
          if (value == 200)
            {
              context.pop(),
            }
        },
      );
    }
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

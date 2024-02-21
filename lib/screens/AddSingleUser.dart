import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSingleUserPage extends StatefulWidget {
  const AddSingleUserPage({Key? key}) : super(key: key);

  @override
  _AddSingleUserPageState createState() => _AddSingleUserPageState();
}

class _AddSingleUserPageState extends State<AddSingleUserPage> {
  TextEditingController sapIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();

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

    print('SAP ID: $sapId');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Roll Number: $rollNumber');


    sapIdController.clear();
    firstNameController.clear();
    lastNameController.clear();
    rollNumberController.clear();


    Fluttertoast.showToast(
      msg: 'Successfully added',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
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

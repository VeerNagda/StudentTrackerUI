import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Users:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('SAP ID')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Roll No')),
                  DataColumn(label: Text('Role')),
                ],
                rows: const [
                  // TODO: Add rows dynamically
                  DataRow(cells: [
                    DataCell(Text('45207210001')),
                    DataCell(Text('Parinaz')),
                    DataCell(Text('Bharucha')),
                    DataCell(Text('A004')),
                    DataCell(Text('Student')),
                  ]),
                ],
              ),
            ),
          ],
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
                      //TODO dont know how to pop using go-routes
                      Navigator.pop(context);
                      context.goNamed('single-user');
                    },
                  ),
                  ListTile(
                    //icon for many peops
                    leading: const Icon(Icons.people_alt),
                    title: const Text('Add Bulk Users'),
                    onTap: () {
                      Navigator.pop(context);
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

  //pop up wala part for bulk user


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

                  if(result != null) {
                    PlatformFile file = result.files.first;
                    print(file.name);
                    print(file.bytes);
                    print(file.size);
                    print(file.extension);
                    print(file.path);
                  } else {
                  }
                },
                child: const Text('Select CSV File'),
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
              onPressed: () {
                // TODO Handle the CSV file and add users
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

}

import 'package:flutter/material.dart';
import 'AddSingleUser.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({Key? key}) : super(key: key);

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
                rows: [
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
          // Show modal bottom sheet with options
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Add Single User'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSingleUserPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people_alt),
                    title: Text('Add Bulk Users'),
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
          title: Text('Add Excel File'),
          content: Text('Still need to do that excel wala part'), // You can customize the content as needed
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class AdminHistory extends StatefulWidget {
  const AdminHistory({super.key});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<AdminHistory> {
  List<String> eventNames = ['Event 1', 'Event 2', 'Event 3']; // Replace with your event names
  String selectedEvent = 'Event 1'; // Default selected event

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe4efe9), Color(0xFF93a5cf)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedEvent,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedEvent = newValue;
                  });
                }
              },
              items: eventNames.map((String eventName) {
                return DropdownMenuItem<String>(
                  value: eventName,
                  child: Text(eventName),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic for handling the selected event
                // You can navigate to another page or perform any action
                print('Selected Event: $selectedEvent');
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

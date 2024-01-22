import 'package:flutter/material.dart';
import 'package:ui/map.dart';
import 'event.dart';
import 'package:latlong2/latlong.dart';


class EventFormResult {
  final Event? event;

  EventFormResult({this.event});
}

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<LatLng> selectedVenues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: collegeNameController,
                decoration: const InputDecoration(labelText: 'College Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the college name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  List<LatLng> selectedVenuesResult = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                  if (selectedVenuesResult != null) {
                    setState(() {
                      selectedVenues = selectedVenuesResult;
                    });
                  }
                },
                child: const Text('Select Venue'),
              ),
              Text('Selected Venues: ${selectedVenues.length}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveEvent();
                },
                child: const Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEvent() {
    // Validate form fields before saving
    if (eventNameController.text.isEmpty || collegeNameController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Create an Event object with the form data
    Event newEvent = Event(
      eventName: eventNameController.text,
      collegeName: collegeNameController.text,
      startDate: startDate,
      endDate: endDate,
      venues: selectedVenues,
    );

    // Return the Event object to the previous screen
    Navigator.pop(context, EventFormResult(event: newEvent));
  }
}

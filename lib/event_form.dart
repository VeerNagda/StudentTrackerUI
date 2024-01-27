import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map.dart';
import 'event.dart';

class EventFormResult {
  final Event? event;

  EventFormResult({this.event});
}

class EventForm extends StatefulWidget {
  final Event? initialEvent; // Add initialEvent named parameter

  const EventForm({Key? key, this.initialEvent}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late TextEditingController eventNameController;
  late TextEditingController collegeNameController;
  DateTime? startDate;
  DateTime? endDate;
  List<LatLng> selectedVenues = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers and other values based on the initialEvent
    eventNameController = TextEditingController(text: widget.initialEvent?.eventName ?? '');
    collegeNameController = TextEditingController(text: widget.initialEvent?.collegeName ?? '');
    startDate = widget.initialEvent?.startDate;
    endDate = widget.initialEvent?.endDate;
    selectedVenues = widget.initialEvent?.venues ?? [];
  }

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField('Event Name', eventNameController),
              const SizedBox(height: 12),
              _buildTextFormField('College Name', collegeNameController),
              const SizedBox(height: 12),
              _buildDateSelectionButton('Start Date', startDate),
              const SizedBox(height: 12),
              _buildDateSelectionButton('End Date', endDate),
              const SizedBox(height: 12),
              _buildVenueSelectionButton(),
              const SizedBox(height: 12),
              _buildSelectedVenuesText(),
              const SizedBox(height: 24),
              _buildSaveEventButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        // Removed border
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateSelectionButton(String label, DateTime? date) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          setState(() {
            if (label == 'Start Date') {
              startDate = pickedDate;
            } else {
              endDate = pickedDate;
            }
          });
        }
      },
      child: Text('$label: ${date?.toLocal().toString() ?? "Pick a date"}'),
    );
  }

  Widget _buildVenueSelectionButton() {
    return ElevatedButton(
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
    );
  }

  Widget _buildSelectedVenuesText() {
    return Text('Selected Venues: ${selectedVenues.length}');
  }

  Widget _buildSaveEventButton() {
    return ElevatedButton(
      onPressed: () {
        _saveEvent();
      },
      child: const Text('Save Event'),
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

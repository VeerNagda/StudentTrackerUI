import 'package:flutter/material.dart';
import 'package:ui/models/event/event_response_model.dart';
import 'map.dart';

class EventFormResult {
  final EventResponseModel? event;

  EventFormResult({this.event});
}

class EventForm extends StatefulWidget {
  final EventResponseModel? initialEvent; // Add initialEvent named parameter

  const EventForm({super.key, this.initialEvent});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late TextEditingController eventIdController;
  late TextEditingController eventNameController;
  DateTime? startDate;
  DateTime? endDate;
  List<Venue> selectedVenues = [];

  @override
  void initState() {
    super.initState();

    // have Initialized controllers and other values based on the initialEvent
    eventIdController = TextEditingController(text: widget.initialEvent?.eventID ?? '');
    eventNameController = TextEditingController(text: widget.initialEvent?.eventName ?? '');
    startDate = widget.initialEvent?.startDate;
    endDate = widget.initialEvent?.endDate;
    selectedVenues = widget.initialEvent?.venue ?? [];
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
              _buildTextFormField('Event Name', eventIdController),
              const SizedBox(height: 12),
              _buildTextFormField('College Name', eventNameController),
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
              startDate = pickedDate; // TODO parinaz Get time to
            } else {
              endDate = pickedDate;
            }
          });
        }
      },
      child: Text('$label: ${date?.toLocal().toString() ?? ""}'),
    );
  }

  Widget _buildVenueSelectionButton() {
    return ElevatedButton(
      onPressed: () async {
        List<Venue> selectedVenuesResult = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
        setState(() {
          selectedVenues = selectedVenuesResult;
        });
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
    //validation
    if (eventIdController.text.isEmpty || eventNameController.text.isEmpty) {

      return;
    }

    EventResponseModel newEvent = EventResponseModel(
      eventID: eventIdController.text,
      eventName: eventNameController.text,
      startDate: startDate,
      endDate: endDate,
      venue: [],
    );

    // Return the Event object to the previous screen
    Navigator.pop(context, EventFormResult(event: newEvent));
  }
}

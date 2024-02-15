import 'package:flutter/material.dart';
import 'package:ui/models/event/event_response_model.dart';
import 'VenueSelectionScreen.dart';

class EventFormResult {
  final EventResponseModel? event;

  EventFormResult({this.event});
}

class EventForm extends StatefulWidget {
  final EventResponseModel? initialEvent; // Add initialEvent named parameter

  const EventForm({Key? key, this.initialEvent}) : super(key: key);

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
              _buildTextFormField('Event ID', eventIdController),
              const SizedBox(height: 12),
              _buildTextFormField('Event Name', eventNameController),
              const SizedBox(height: 12),
              _buildDateRangeSelectionButton('Date Range', startDate, endDate),
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

  // for date time
  Widget _buildDateRangeSelectionButton(String label, DateTime? startDate, DateTime? endDate) {
    return ElevatedButton(
      onPressed: () async {
        DateTimeRange? pickedDateTimeRange = await showDateRangePicker(
          context: context,
          initialDateRange: DateTimeRange(
            start: startDate ?? DateTime.now(),
            end: endDate ?? DateTime.now(),
          ),
          firstDate: DateTime.now(),
          lastDate: DateTime(2080), //gave random year
          initialEntryMode: DatePickerEntryMode.calendarOnly,
        );

        if (pickedDateTimeRange != null) {
          DateTime? startDateTime = (await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(pickedDateTimeRange.start),
          )) as DateTime?;

          DateTime? endDateTime = (await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(pickedDateTimeRange.end),
          )) as DateTime?;

          if (startDateTime != null && endDateTime != null) {
            setState(() {
              startDate = DateTime(
                pickedDateTimeRange.start.year,
                pickedDateTimeRange.start.month,
                pickedDateTimeRange.start.day,
                startDateTime.hour,
                startDateTime.minute,
              );

              endDate = DateTime(
                pickedDateTimeRange.end.year,
                pickedDateTimeRange.end.month,
                pickedDateTimeRange.end.day,
                endDateTime.hour,
                endDateTime.minute,
              );
            });
          }
        }
      },
      child: Text('$label: ${_formatDateTime(startDate)} - ${_formatDateTime(endDate)}'),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return '${dateTime.toLocal().toString()}';
    } else {
      return '';
    }
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

  Widget _buildVenueSelectionButton() {
    return ElevatedButton(
      onPressed: () async {
        List<Venue> selectedVenuesResult = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VenueSelectionScreen()),
        );
        setState(() {
          selectedVenues = selectedVenuesResult;
        });
      },
      child: const Text('Select Venue'),
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

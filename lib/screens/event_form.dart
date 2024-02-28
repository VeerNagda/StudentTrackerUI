import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/models/event/event_response_model.dart';

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

  // for venue pop up
  List<Venue> venues = [
    Venue(venueID: '1', venueName: 'Venue 1'),
    Venue(venueID: '2', venueName: 'Venue 2'),
    Venue(venueID: '3', venueName: 'Venue 3'),
    Venue(venueID: '4', venueName: 'Venue 4'),
    Venue(venueID: '5', venueName: 'Venue 5'),
    Venue(venueID: '6', venueName: 'Venue 6'),
    Venue(venueID: '7', venueName: 'Venue 7'),
    Venue(venueID: '8', venueName: 'Venue 8'),
    Venue(venueID: '9', venueName: 'Venue 9'),
    Venue(venueID: '4', venueName: 'Venue 4'),

  ];

  @override
  void initState() {
    super.initState();

    eventIdController = TextEditingController(text: widget.initialEvent?.eventID ?? '');
    eventNameController = TextEditingController(text: widget.initialEvent?.eventName ?? '');
    startDate = widget.initialEvent?.startDate ;
    endDate = widget.initialEvent?.endDate ;
    selectedVenues = widget.initialEvent?.venue ?? [];

    // event id is disabled
    if (widget.initialEvent != null) {
      eventIdController.text = widget.initialEvent!.eventID;
      eventNameController.text = widget.initialEvent!.eventName;
      eventIdController.selection = TextSelection.fromPosition(TextPosition(offset: eventIdController.text.length));
      eventIdController.addListener(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.initialEvent != null;

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
              _buildTextFormField('Event ID', eventIdController, !isEditing), // Disable only when editing
              const SizedBox(height: 12),
              _buildTextFormField('Event Name', eventNameController, true), // Enable for both editing and creating
              const SizedBox(height: 12),
              _buildDateRangeSelectionButton('Start Date and End Date '),
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

  Widget _buildTextFormField(String label, TextEditingController controller, bool enabled) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      enabled: enabled, // true false based
      readOnly: !enabled,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateRangeSelectionButton(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            final initialStartDate = startDate ?? DateTime.now();
            final initialEndDate = endDate ?? initialStartDate;

            DateTime? pickedStartDate = await showDatePicker(
              context: context,
              initialDate: initialStartDate,
              firstDate: DateTime(2024),
              lastDate: DateTime(2100),
            );

            if (pickedStartDate != null) {
              TimeOfDay? pickedStartTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(pickedStartDate),
              );

              if (pickedStartTime != null) {
                DateTime? pickedEndDate = await showDatePicker(
                  context: context,
                  initialDate: initialEndDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100),
                );

                if (pickedEndDate != null) {
                  TimeOfDay? pickedEndTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(pickedEndDate),
                  );

                  if (pickedEndTime != null) {
                    setState(() {
                      startDate = DateTime(
                        pickedStartDate.year,
                        pickedStartDate.month,
                        pickedStartDate.day,
                        pickedStartTime.hour,
                        pickedStartTime.minute,
                      );
                      endDate = DateTime(
                        pickedEndDate.year,
                        pickedEndDate.month,
                        pickedEndDate.day,
                        pickedEndTime.hour,
                        pickedEndTime.minute,
                      );
                    });
                  }
                }
              }
            }
          },
          child: Text('$label: ${_formatDateTime(startDate)} - ${_formatDateTime(endDate)}'),
        ),
      ],
    );
  }


  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat.yMMMMd().add_jm().format(dateTime);
    } else {
      return 'Not set';
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
        List<Venue>? selectedVenuesResult = await showDialog<List<Venue>>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Venue'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 200, // Adjust the height according to your requirement
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              venues.length,
                                  (index) {
                                final venue = venues[index];
                                return CheckboxListTile(
                                  title: Text(venue.venueName),
                                  value: selectedVenues.contains(venue),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedVenues.add(venue);
                                      } else {
                                        selectedVenues.remove(venue);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedVenues.clear(); // Clear all selected venues
                              });
                            },
                            child: const Text('Clear All'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, selectedVenues);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
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




  void _saveEvent() {
    if (eventIdController.text.isEmpty || eventNameController.text.isEmpty) {
      return;
    }

    EventResponseModel newEvent = EventResponseModel(
      eventID: eventIdController.text,
      eventName: eventNameController.text,
      startDate: startDate,
      endDate: endDate,
      venue: selectedVenues,
    );

    Navigator.pop(context, EventFormResult(event: newEvent));
  }
}

import 'package:flutter/material.dart';
import 'package:ui/models/event/event_response_model.dart';

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

  // for venue pop up
  List<Venue> venues = [
    Venue(venueID: '1', venueName: 'Venue 1'),
    Venue(venueID: '2', venueName: 'Venue 2'),
    Venue(venueID: '3', venueName: 'Venue 3'),
  ];

  @override
  void initState() {
    super.initState();

    eventIdController = TextEditingController(text: widget.initialEvent?.eventID ?? '');
    eventNameController = TextEditingController(text: widget.initialEvent?.eventName ?? '');
    startDate = widget.initialEvent?.startDate;
    endDate = widget.initialEvent?.endDate;
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
              _buildDateRangeSelectionButton('Start Date and End Date ', startDate, endDate),
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

  Widget _buildDateRangeSelectionButton(String label, DateTime? startDate, DateTime? endDate) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    return ElevatedButton(
      onPressed: () async {
        DateTime? pickedStartDate = await showDatePicker(
          context: context,
          initialDate: startDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2080),
        );

        if (pickedStartDate != null) {
          startTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (startTime != null) {
            DateTime? pickedEndDate = await showDatePicker(
              context: context,
              initialDate: endDate ?? pickedStartDate,
              firstDate: pickedStartDate,
              lastDate: DateTime(2080),
            );

            if (pickedEndDate != null) {
              endTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (endTime != null) {
                setState(() {
                  startDate = DateTime(
                    pickedStartDate.year,
                    pickedStartDate.month,
                    pickedStartDate.day,
                    startTime!.hour,
                    startTime!.minute,
                  );

                  endDate = DateTime(
                    pickedEndDate.year,
                    pickedEndDate.month,
                    pickedEndDate.day,
                    endTime!.hour,
                    endTime!.minute,
                  );
                });
              }
            }
          }
        }
      },
      child: Text('$label: ${_formatDateTime(startDate)} ${_formatTime(startTime)} - ${_formatDateTime(endDate)} ${_formatTime(endTime)}'),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return dateTime.toLocal().toString();
    } else {
      return '';
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time != null) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
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
        List<Venue>? selectedVenuesResult = await showDialog<List<Venue>>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select Venue'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
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
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedVenues.clear(); // Clear all selected venues
                              });
                            },
                            child: Text('Clear All'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, selectedVenues);
                            },
                            child: Text('Save'),
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

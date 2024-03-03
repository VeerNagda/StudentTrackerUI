import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui/models/StudentGroup/group_list_response_model.dart';
import 'package:ui/models/event/event_all_data_model.dart';
import 'package:ui/models/venue/venue_response_model.dart';
import 'package:ui/services/api_service.dart';



class EventForm extends StatefulWidget {
  final String? eventId;

  const EventForm({super.key, required this.eventId});

  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  late TextEditingController eventIdController;
  late TextEditingController eventNameController;
  DateTime? startDate;
  DateTime? endDate;
  List<String> selectedVenues = [];
  List<String> selectedGroups = [];

  EventAllDataModel? event;

  late List<VenueResponseModel> venues = [];
  late List<GroupListResponseModel> groups = [];

  // for venue pop up

  void _fetchEventData() {
    var eventId = widget.eventId;
    APIService.doGet(path: "/admin/event/event-details/$eventId")
        .then((value) => {
              if (value != "")
                {
                  event = EventAllDataModel.fromJson(jsonDecode(value)),
                  if (event != null)
                    {
                      eventIdController =
                          TextEditingController(text: event?.event.iD ?? ''),
                      eventNameController =
                          TextEditingController(text: event?.event.name ?? ''),
                      startDate = event?.event.startDate,
                      endDate = event?.event.endDate,
                      for (var venue in event?.venues ?? [])
                        {
                          selectedVenues.add(venue.iD),
                        },
                      for (var group in event?.groups ?? [])
                        {
                          selectedGroups.add(group.iD),
                        },
                    },
                  setState(() {}),
                }
            });
  }

  void _fetchVenuesGroups() {
    APIService.doGet(path: "/admin/venue/all-venues").then((value) {
      if (value != "") {
        setState(() {
          venues = jsonDecode(value)
              .map<VenueResponseModel>(
                  (item) => VenueResponseModel.fromJson(item))
              .toList();
        });
      }
    });
    APIService.doGet(path: "/admin/group/all-groups").then((value) {
      if (value != "") {
        setState(() {
          groups = jsonDecode(value)
              .map<GroupListResponseModel>(
                  (item) => GroupListResponseModel.fromJson(item))
              .toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    eventIdController = TextEditingController();
    _fetchVenuesGroups();
    if (widget.eventId != null) {
      _fetchEventData();
    }

    //selectedVenues = widget.initialEvent?.venue ?? [];

    // event id is disabled
    if (widget.eventId != null && event != null) {
      eventIdController.text = event?.event.iD ?? "";
      eventNameController.text = event?.event.name ?? "";
      eventIdController.selection = TextSelection.fromPosition(
          TextPosition(offset: eventIdController.text.length));
      eventIdController.addListener(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = event != null;

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
              _buildTextFormField('Event ID', eventIdController, !isEditing),
              // Disable only when editing
              const SizedBox(height: 12),
              _buildTextFormField('Event Name', eventNameController, true),
              // Enable for both editing and creating
              const SizedBox(height: 12),
              _buildDateRangeSelectionButton(),
              const SizedBox(height: 12),
              _buildVenueSelectionButton(),
              const SizedBox(height: 12),
              _buildSelectedVenuesText(),
              const SizedBox(height: 12),
              _buildGroupSelectionButton(),
              const SizedBox(height: 12),
              _buildSelectedGroupsText(),
              const SizedBox(height: 24),
              _buildSaveEventButton(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String label, TextEditingController controller, bool enabled) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      enabled: enabled,
      // true false based
      readOnly: !enabled,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateRangeSelectionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            final initialStartDate = startDate ?? DateTime.now();

            DateTime? pickedStartDate = await showDatePicker(
              context: context,
              initialDate: initialStartDate,
              firstDate: DateTime(2024),
              lastDate: DateTime(2100),
            );

            if (pickedStartDate != null && mounted) {
              TimeOfDay? pickedStartTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(pickedStartDate),
              );

              if (pickedStartTime != null && mounted) {
                setState(() {
                  startDate = DateTime(
                    pickedStartDate.year,
                    pickedStartDate.month,
                    pickedStartDate.day,
                    pickedStartTime.hour,
                    pickedStartTime.minute,
                  );
                });
              }
            }
          },
          child: Text('Start Date: ${_formatDateTime(startDate)}'),
        ),
        ElevatedButton(
          onPressed: () async {
            final initialEndDate = endDate ?? DateTime.now();

            DateTime? pickedEndDate = await showDatePicker(
              context: context,
              initialDate: initialEndDate,
              firstDate: DateTime(2024),
              lastDate: DateTime(2100),
            );

            if (pickedEndDate != null && mounted) {
              TimeOfDay? pickedEndTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(pickedEndDate),
              );

              if (pickedEndTime != null) {
                setState(() {
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
          },
          child: Text('End Date: ${_formatDateTime(endDate)}'),
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

  //group
  Widget _buildSelectedGroupsText() {
    return Text('Selected Groups: ${selectedGroups.length}');
  }

  Widget _buildSaveEventButton(bool isEditing) {
    return ElevatedButton(
      onPressed: () {
        _saveEvent(isEditing);
      },
      child: const Text('Save Event'),
    );
  }

  Widget _buildVenueSelectionButton() {
    return ElevatedButton(
      onPressed: () async {
        List<String>? selectedVenuesResult = await showDialog<List<String>>(
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
                        height: 200,
                        // Adjust the height according to your requirement
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              venues.length,
                              (index) {
                                final venue = venues[index];
                                return CheckboxListTile(
                                  title: Text(venue.name),
                                  value: selectedVenues.contains(venue.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedVenues.add(venue.id);
                                      } else {
                                        selectedVenues.remove(venue.id);
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
                                selectedVenues
                                    .clear(); // Clear all selected venues
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

  Widget _buildGroupSelectionButton() {
    return ElevatedButton(
      onPressed: () async {
        List<String>? selectedGroupsResult = await showDialog<List<String>>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Group'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 200,
                        // Adjust the height according to your requirement
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              groups.length,
                              (index) {
                                final group = groups[index];
                                return CheckboxListTile(
                                  title: Text(group.name),
                                  value: selectedGroups.contains(group.iD),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedGroups.add(group.iD);
                                      } else {
                                        selectedGroups.remove(group.iD);
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
                                selectedGroups
                                    .clear(); // Clear all selected venues
                              });
                            },
                            child: const Text('Clear All'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, selectedGroups);
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
        if (selectedGroupsResult != null) {
          setState(() {
            selectedGroups = selectedGroupsResult;
          });
        }
      },
      child: const Text('Select Group'),
    );
  }

  void _saveEvent(bool isEditing) {
    if (eventIdController.text.isEmpty || eventNameController.text.isEmpty) {
      return;
    }


    if(!isEditing) {
      Map<String, dynamic> data = {
        "id": eventIdController.text,
        "name": eventNameController.text,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "venues": selectedVenues,
        "groups": selectedGroups,
      };
      APIService.doPostInsert(
          context: context, data: data, path: "/admin/event/add-event")
          .then(
            (value) =>
        {
          if (value == 201)
            {
              context.pop(),
            }
        },
      );
    }
    else{
      Map<String, dynamic> data = {
        "name": eventNameController.text,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "venues": selectedVenues,
        "groups": selectedGroups,
      };
      APIService.doPut(
          context: context, data: data, path: "/admin/event/update-event",param: eventIdController.text)
          .then(
            (value) =>
        {
          if (value == 201)
            {
              context.pop(),
            }
        },
      );
    }
  }
}

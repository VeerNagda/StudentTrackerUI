import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:ui/models/event/event_response_model.dart';
import 'package:ui/services/api_service.dart';
import 'event_form.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late List<EventResponseModel> events = [];

  @override
  void initState() {
    super.initState();
    APIService.doGet(path: "/admin/get-upcoming-events").then((value) => {
      if (value != "")
        {
          setState(() {
            events = jsonDecode(value)
                .map<EventResponseModel>(
                    (item) => EventResponseModel.fromJson(item))
                .toList();
          }),
          print(events)
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: events.isEmpty
            ? const Center(
          child: Text(
            'No events yet. '
                'Tap the + button to add an event.',
            style: TextStyle(fontSize: 16.0),
          ),
        )
            : ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(events[index].eventName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venues: ${events[index].venue?.length}'),
                    Text('Date: ${_formatDateTime(events[index].startDate)} - ${_formatDateTime(events[index].endDate)}'),
                  ],
                ),
                onTap: () {
                  _navigateToEventDetails(events[index]);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEventFormForEditing(events[index]);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(events[index]);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToEventForm();
        },
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  _navigateToEventForm() async {
    EventFormResult result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventForm()),
    );
    if (result.event != null) {
      setState(() {
        events.add(result.event!);
      });
    }
  }

  _navigateToEventFormForEditing(EventResponseModel event) async {
    EventFormResult result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventForm(initialEvent: event),
      ),
    );


    if (result.event != null) {
      setState(() {
        events.remove(event);
        events.add(result.event!);
      });
    }
  }

  _showDeleteConfirmationDialog(EventResponseModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(event);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  _deleteEvent(EventResponseModel event) {
    Map<String, String> query = {
      "eventId": event.eventID
    };
    APIService.doDelete(path: "/admin/delete-event", query: query).then((value) => {
      if (value == "Success")
        {
          setState(() {
            events.remove(event);
          })
        }
    });
  }

  _navigateToEventDetails(EventResponseModel selectedEvent) {
    print('Selected Event Details:');
    print('Event ID: ${selectedEvent.eventID}');
    print('Event Name: ${selectedEvent.eventName}');
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat.yMMMMd().add_jm().format(dateTime);
    } else {
      return '';
    }
  }
}

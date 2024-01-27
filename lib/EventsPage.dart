import 'package:flutter/material.dart';
import 'event.dart';
import 'event_form.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        //this will by default remove the arrow we get
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: events.isEmpty
            ? Center(
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
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(events[index].eventName),
                subtitle: Text('Venues: ${events[index].venues.length}'),
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

    if (result != null && result.event != null) {
      setState(() {
        events.add(result.event!);
      });
    }
  }

  _navigateToEventFormForEditing(Event event) async {
    EventFormResult result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventForm(initialEvent: event),
      ),
    );

    if (result != null && result.event != null) {
      setState(() {
        events.remove(event);
        events.add(result.event!);
      });
    }
  }

  _showDeleteConfirmationDialog(Event event) {
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

  _deleteEvent(Event event) {
    setState(() {
      events.remove(event);
    });
  }

  _navigateToEventDetails(Event selectedEvent) {
    print('Selected Event Details:');
    print('Event Name: ${selectedEvent.eventName}');
    print('College Name: ${selectedEvent.collegeName}');
  }
}

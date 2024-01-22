import 'package:flutter/material.dart';
import 'package:ui/event.dart';
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
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index].eventName),
            subtitle: Text('Venues: ${events[index].venues.length}'),
            onTap: () {
              // TODO: Navigate to a detailed view or edit page for the event
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToEventForm();
        },
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
}

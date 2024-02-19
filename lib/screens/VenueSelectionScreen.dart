import 'package:flutter/material.dart';

import '../models/event/event_response_model.dart';

class VenueSelectionScreen extends StatefulWidget {
  const VenueSelectionScreen({super.key});

  @override
  _VenueSelectionScreenState createState() => _VenueSelectionScreenState();
}

class _VenueSelectionScreenState extends State<VenueSelectionScreen> {
  // List of venues for demonstration purposes
  List<Venue> venues = [
    Venue(venueID: '1', venueName: 'Venue 1'),
    Venue(venueID: '2', venueName: 'Venue 2'),
    Venue(venueID: '3', venueName: 'Venue 3', ),
  ];

  List<Venue> selectedVenues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Venues'),
      ),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedVenues);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

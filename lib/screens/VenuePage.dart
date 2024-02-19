import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/venue/venue_response_model.dart';
import '../services/api_service.dart';
import 'AddVenuePage.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({Key? key}) : super(key: key);

  @override
  _VenuesPageState createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  late List<VenueResponseModel> venues = [];

  @override
  void initState() {
    super.initState();
    _fetchVenues();
  }

  void _fetchVenues() {
    APIService.doGet(path: "/admin/get-venues").then((value) {
      if (value != "") {
        setState(() {
          venues = (jsonDecode(value) as List)
              .map((item) => VenueResponseModel.fromJson(item))
              .toList();
        });
      }
    });
  }

  void _navigateToAddVenue() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVenuePage(onSaveVenue: _handleAddVenue)),
    );
  }

  void _handleAddVenue(VenueResponseModel newVenue) {
    setState(() {
      venues.add(newVenue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: venues.isEmpty
            ? const Center(
          child: Text(
            'No venues found.',
            style: TextStyle(fontSize: 16.0),
          ),
        )
            : ListView.builder(
          itemCount: venues.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(venues[index].venueName),
                onTap: () {
                  _navigateToVenueDetails(venues[index]);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditVenue(venues[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(venues[index]);
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
          _navigateToAddVenue();
        },
        tooltip: 'Add Venue',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditVenue(VenueResponseModel venue) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVenuePage(initialVenue: venue, onSaveVenue: _handleEditVenue),
      ),
    );
  }

  void _handleEditVenue(VenueResponseModel editedVenue) {
    setState(() {
      final index = venues.indexWhere((venue) => venue.venueID == editedVenue.venueID);
      if (index != -1) {
        venues[index] = editedVenue;
      }
    });
  }

  void _showDeleteConfirmationDialog(VenueResponseModel venue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Venue'),
          content: const Text('Are you sure you want to delete this venue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteVenue(venue);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVenue(VenueResponseModel venue) {
    Map<String, String> query = {
      "venueId": venue.venueID
    };
    APIService.doDelete(path: "/admin/delete-venue", query: query).then((value) {
      if (value == "Success") {
        setState(() {
          venues.remove(venue);
        });
      }
    });
  }

  _navigateToVenueDetails(VenueResponseModel selectedEvent) {
    print('Selected Venue Details:');
    print('Venue ID: ${selectedEvent.venueID}');
    print('Venue Name: ${selectedEvent.venueName}');
  }
}

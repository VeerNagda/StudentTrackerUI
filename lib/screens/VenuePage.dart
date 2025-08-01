import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/venue/venue_response_model.dart';
import '../services/api_service.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

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
    APIService.doGet(path: "/admin/venue/all-venues").then((value) {
      if (value != "") {
        setState(() {
          venues = jsonDecode(value)
              .map<VenueResponseModel>(
                  (item) => VenueResponseModel.fromJson(item))
              .toList();
        });
        //context.pop();
      }
    });
  }


  void _navigateToAddVenue() async {
    context.goNamed('add-venue');
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
                title: Text(venues[index].name),
                onTap: () {
                  _navigateToVenueDetails(venues[index]);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditVenue(venues[index]);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
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
    context.pushNamed('add-venue');
  }

  void _handleEditVenue(VenueResponseModel editedVenue) {
    setState(() {
      final index = venues.indexWhere((venue) => venue.id == editedVenue.id);
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
               context.pop();

              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVenue(VenueResponseModel venue) {
    APIService.doDelete(path: "/admin/venue/delete-venue", param: venue.id).then((value) {
      if (value == 204) {
        setState(() {
          _fetchVenues();
        });
      }
    });
  }

  _navigateToVenueDetails(VenueResponseModel selectedEvent) {
    if (kDebugMode) {
      print('Selected Venue Details:');
      print('Venue ID: ${selectedEvent.id}');
      print('Venue Name: ${selectedEvent.id}');
    }
  }
}

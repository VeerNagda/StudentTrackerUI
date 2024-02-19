import 'package:flutter/material.dart';
import '../models/venue/venue_response_model.dart';
import 'map.dart';
class AddVenuePage extends StatefulWidget {
  final VenueResponseModel? initialVenue;
  final Function(VenueResponseModel) onSaveVenue;

  const AddVenuePage({super.key, this.initialVenue, required this.onSaveVenue});

  @override
  _AddVenuePageState createState() => _AddVenuePageState();
}

class _AddVenuePageState extends State<AddVenuePage> {
  late TextEditingController venueIdController;
  late TextEditingController venueNameController;

  @override
  void initState() {
    super.initState();

    venueIdController = TextEditingController(text: widget.initialVenue?.venueID ?? '');
    venueNameController = TextEditingController(text: widget.initialVenue?.venueName ?? '');

    // event id is disabled
    if (widget.initialVenue != null) {
      venueIdController.text = widget.initialVenue!.venueID;
      venueIdController.text = widget.initialVenue!.venueID;
      venueIdController.selection = TextSelection.fromPosition(TextPosition(offset: venueIdController.text.length));
      venueIdController.addListener(() {});
    }
  }

  void _saveVenue(BuildContext context) {
    // Validation
    if (venueIdController.text.isEmpty || venueNameController.text.isEmpty) {
      return;
    }

    VenueResponseModel newVenue = VenueResponseModel(
      venueID: venueIdController.text,
      venueName: venueNameController.text,
    );

    widget.onSaveVenue(newVenue); // Callback to add the new venue
    Navigator.pop(context); // Close the AddVenuePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Venue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveVenue(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: venueIdController,
                decoration: const InputDecoration(labelText: 'Venue ID'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: venueNameController,
                decoration: const InputDecoration(labelText: 'Venue Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                child: const Text('Choose Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

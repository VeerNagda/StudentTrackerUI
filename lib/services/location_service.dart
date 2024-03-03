import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ui/models/location/location_request_model.dart';

import 'api_service.dart';

class LocationService {
  static LocationRequestModel? location;

  static Future<void> getPosition(String sapId, String eventId) async {
    Position? position;
    try {
      position = await getCurrentPosition();
    } catch (e) {
      if (kDebugMode) {
        print('Error in background task: $e');
      }
    } finally {
      if (sapId != "") {
        location ??= LocationRequestModel(sapId: sapId, eventID: eventId);
        TimedCoordinates timedCoordinates = TimedCoordinates(
            coordinates: [position!.latitude, position.longitude],
            dateTime: DateTime.now().toIso8601String());
        location!.timedCoordinates.add(timedCoordinates);
        if (kDebugMode) {
          print(location!.toJson());
        }
        int response = await APIService.doPostInsert(
            data: location!.toJson(),
            path: "/user/save-location",
            context: null);
        if (response == 201) {
          location!.timedCoordinates = [];
        }
      }
    }
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}

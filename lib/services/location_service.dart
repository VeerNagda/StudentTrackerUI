import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/location/location_request_model.dart';
import 'package:ui/services/shared_service.dart';

import 'api_service.dart';

class LocationService {
  static List<LatLng> coordinates = [];
  static LocationRequestModel? location;

  static Future<void> getPosition(String sapId, String eventId) async {
    Position? position;
    try {
      position = await getCurrentPosition();
      coordinates.add(LatLng(position.latitude, position.longitude));
    } catch (e) {
      if (kDebugMode) {
        print('Error in background task: $e');
      }
    } finally {
      if (sapId != "" && coordinates.isNotEmpty) {
        location ??= LocationRequestModel(sapId: sapId, eventID: eventId);
        TimedCoordinates timedCoordinates = TimedCoordinates(
            coordinates: [LatLng(position!.latitude, position.longitude)],
            dateTime: DateTime.now().toIso8601String());
        location!.timedCoordinates ??= [];
        location!.timedCoordinates?.add(timedCoordinates);
        if (kDebugMode) {
          print(location!.toJson());
        }
        int response = await APIService.doPostInsert(
            data: location!.toJson(),
            path: "/user/event/user-current-location",
            context: null);
        if (response == 201) {
          coordinates = [];
          location!.timedCoordinates = [];
        }
      }
    }
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}

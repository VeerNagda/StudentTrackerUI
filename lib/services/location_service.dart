import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/models/location/location_request_model.dart';
import 'package:ui/services/shared_service.dart';

import 'api_service.dart';


class LocationService {

  static List<LatLng> coordinates = [];

  static Future<void> getPosition() async {
    try {
      Position position = await getCurrentPosition();
      coordinates.add(LatLng(position.latitude, position.longitude));
    } catch (e) {
      if (kDebugMode) {
        print('Error in background task: $e');
      }
    } finally{
      if (SharedService.sapId != "" && coordinates.isNotEmpty) {
        LocationRequestModel location = LocationRequestModel(
            sapId: SharedService.sapId, eventID: SharedService.eventId);
        location.dateTime = DateTime.now();
        location.coordinates = coordinates;
        print(location.toJson());
        int response = await APIService.doPostInsert(data: location.toJson(), path: "/user-current-location", context: null);
        if(response == 201){
          coordinates = [];
        }
      }
    }
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}
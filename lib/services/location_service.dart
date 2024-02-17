import 'dart:async';

import 'package:geolocator/geolocator.dart';



class LocationService {


  static Future<void> getPosition() async {
    try {
      Position position = await _getCurrentPosition();
      // Perform your background task, such as inserting data into the database
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error in background task: $e');
    }
  }

  static Future<Position> _getCurrentPosition() async {

    return await Geolocator.getCurrentPosition();
  }
}
import 'dart:convert';

import 'package:latlong2/latlong.dart';

VenueResponseModel loginResponseJson(String str) =>
    VenueResponseModel.fromJson(jsonDecode(str));

class VenueResponseModel {
  final String id;
  final String name;
  final List<List<LatLng>> coordinates;

  VenueResponseModel({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  factory VenueResponseModel.fromJson(Map<String, dynamic> json) {
    List<List<LatLng>> parsedCoordinates = [];
    for (var coordsList in json['Coordinates']) {
      List<LatLng> latLngList = [];
      for (var coords in coordsList) {
        latLngList.add(LatLng(coords['y'], coords['x']));
      }
      parsedCoordinates.add(latLngList);
    }

    return VenueResponseModel(
      id: json['ID'],
      name: json['Name'],
      coordinates: parsedCoordinates,
    );
  }
}

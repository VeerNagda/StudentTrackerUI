import 'package:latlong2/latlong.dart';

class VenueRequestModel {
  late String _id;
  late String _name;
  late List<LatLng> _coordinates;

  String get id => _id;

  set id(String id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  List<LatLng> get coordinates => _coordinates;

  set coordinates(List<LatLng> coordinates) => _coordinates = coordinates;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['coordinates'] = _coordinates.map((v) => v.toJson()).toList();
    return data;
  }
}

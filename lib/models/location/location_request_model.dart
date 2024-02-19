import 'package:latlong2/latlong.dart';

class LocationRequestModel {
  late String sapId;
  late DateTime dateTime;
  late String eventID;
  late List<LatLng> coordinates;

  LocationRequestModel({required this.sapId, required this.eventID});

  LocationRequestModel.fromJson(Map<String, dynamic> json) {
    sapId = json['SAP_ID'];
    dateTime = json['DateTime'];
    eventID = json['Event_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SAP_ID'] = sapId;
    data['DateTime'] = dateTime;
    data['Event_ID'] = eventID;
    data['coordinates'] = coordinates.map((v) => v.toJson()).toList();
    return data;
  }
}
import 'package:latlong2/latlong.dart';

class LocationRequestModel {
  late String sapId;
  late String eventID;
  late List<TimedCoordinates> timedCoordinates = [];

  LocationRequestModel({required this.sapId, required this.eventID});

  LocationRequestModel.fromJson(Map<String, dynamic> json) {
    sapId = json['SAP_ID'];
    eventID = json['Event_ID'];
    if (json['timedCoordinates'] != null) {
      timedCoordinates = [];
      json['timedCoordinates'].forEach((v) {
        timedCoordinates.add(TimedCoordinates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SAP_ID'] = sapId;
    data['Event_ID'] = eventID;
    data['timedCoordinates'] =
        timedCoordinates.map((v) => v.toJson()).toList();
      return data;
  }
}

class TimedCoordinates {
  late List<LatLng> coordinates;
  late String dateTime;

  TimedCoordinates({required this.coordinates, required this.dateTime});

  TimedCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    dateTime = json['DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['DateTime'] = dateTime;
    return data;
  }
}

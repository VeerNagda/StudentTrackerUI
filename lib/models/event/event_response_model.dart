
import 'dart:convert';

EventResponseModel eventResponseJson(String str) =>
    EventResponseModel.fromJson(jsonDecode(str));


class EventResponseModel {
  late String eventID;
  late String eventName;
  late DateTime? startDate;
  late DateTime? endDate;
  late List<Venue>? venue;

  EventResponseModel(
      {required this.eventID, required this.eventName,  this.startDate, this.endDate, required this.venue});

  EventResponseModel.fromJson(Map<String, dynamic> json) {
    eventID = json['Event_ID'];
    eventName = json['Event_Name'];
    startDate = DateTime.parse(json['Start_Date']).toLocal();
    endDate = DateTime.parse(json['End_Date']).toLocal();
    if (json['Venue'] != null) {
      venue = [];
      json['Venue'].forEach((v) {
        venue?.add(Venue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Event_ID'] = eventID;
    data['Event_Name'] = eventName;
    data['Start_Date'] = startDate;
    data['End_Date'] = endDate;
    if (venue != null) {
      data['Venue'] = venue?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venue {
  late String venueID;
  late String venueName;

  Venue({required this.venueID, required this.venueName});

  Venue.fromJson(Map<String, dynamic> json) {
    venueID = json['Venue_ID'];
    venueName = json['Venue_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Venue_ID'] = venueID;
    data['Venue_Name'] = venueName;
    return data;
  }
}

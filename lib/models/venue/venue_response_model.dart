import 'dart:convert';

VenueResponseModel venueResponseJson(String str) =>
    VenueResponseModel.fromJson(jsonDecode(str));

class VenueResponseModel {
  late String venueID;
  late String venueName;

  VenueResponseModel({required this.venueID, required this.venueName});

  VenueResponseModel.fromJson(Map<String, dynamic> json) {
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

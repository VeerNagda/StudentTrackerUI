import 'dart:convert';

CurrentDayEventResponseModel currentDayEventJson(String str) =>
    CurrentDayEventResponseModel.fromJson(jsonDecode(str));

DateTime? findEndTimeByEventId(
    CurrentDayEventResponseModel model, String eventId) {
  Events? event = model.events
      ?.firstWhere((element) => element.ID == eventId);
  if (event != null) {
    return DateTime.parse(event.endDate!);
  } else {
    return null; // Return null if event is not found
  }
}

class CurrentDayEventResponseModel {
  List<Events>? events;

  CurrentDayEventResponseModel({this.events});

  CurrentDayEventResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events?.add(Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (events != null) {
      data['events'] = events?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  String? ID;
  String? name;
  String? endDate;

  Events({this.ID, this.name, this.endDate});

  Events.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    name = json['Name'];
    endDate = json['End_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['Name'] = name;
    data['End_Date'] = endDate;
    return data;
  }
}

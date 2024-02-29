import 'dart:convert';

EventAllDataModel eventAllDataJson(String str) =>
    EventAllDataModel.fromJson(jsonDecode(str));

class EventAllDataModel {
  late Event event;
  late List<Venues> venues;
  late List<Groups> groups;

  EventAllDataModel({required this.event, required this.venues, required this.groups});

  EventAllDataModel.fromJson(Map<String, dynamic> json) {
    event = (json['event'] != null ? Event.fromJson(json['event']) : null)!;
    if (json['venues'] != null) {
      venues = [];
      json['venues'].forEach((v) {
        venues.add(Venues.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = [];
      json['groups'].forEach((v) {
        groups.add(Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event.toJson();
      data['venues'] = venues.map((v) => v.toJson()).toList();
      data['groups'] = groups.map((v) => v.toJson()).toList();
      return data;
  }
}

class Event {
  late String iD;
  late String name;
  late DateTime startDate;
  late DateTime endDate;

  Event({required this.iD, required this.name, required this.startDate, required this.endDate});

  Event.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    startDate = DateTime.parse(json['Start_Date']);
    endDate= DateTime.parse(json['End_Date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['Start_Date'] = startDate.toIso8601String();
    data['End_Date'] = endDate.toIso8601String();
    return data;
  }
}

class Venues {
  late String iD;
  late String name;

  Venues({required this.iD, required this.name});

  Venues.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    return data;
  }
}


class Groups {
  late String iD;
  late String name;

  Groups({required this.iD, required this.name});

  Groups.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    return data;
  }
}
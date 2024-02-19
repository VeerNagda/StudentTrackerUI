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
  String? iD;
  String? name;
  String? endDate;

  Events({this.iD, this.name, this.endDate});

  Events.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    endDate = json['End_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['End_Date'] = endDate;
    return data;
  }
}

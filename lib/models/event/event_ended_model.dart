class EventsEndedModel {
  late String iD;
  late String name;
  late DateTime endDate;

  EventsEndedModel({required this.iD, required this.name, required this.endDate});

  EventsEndedModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    endDate = DateTime.parse(json['End_Date']).toLocal();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['End_Date'] = endDate.toString();
    return data;
  }
}
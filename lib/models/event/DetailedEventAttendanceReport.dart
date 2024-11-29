class DetailedEventAttendanceReport {
  late String id;
  late DateTime time;
  late String coordinates;
  late int systemDecision;

  DetailedEventAttendanceReport({
    required this.id,
    required this.time,
    required this.coordinates,
    required this.systemDecision,
  });

  DetailedEventAttendanceReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = DateTime.parse(json['time']).toLocal();
    coordinates = _parseCoordinates(json['coordinates']);
    systemDecision = json['System_Decision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time.toUtc().toIso8601String();
    data['coordinates'] = coordinates;
    data['System_Decision'] = systemDecision;
    return data;
  }
  String _parseCoordinates(String point) {
    // Extract the coordinates from the POINT() format
    final regex = RegExp(r"POINT\(([-\d.]+) ([-\d.]+)\)");
    final match = regex.firstMatch(point);

    if (match != null) {
      final latitude = match.group(1);
      final longitude = match.group(2);
      return "Lat:$latitude Long:$longitude";
    }

    return "Invalid coordinates";
  }
}

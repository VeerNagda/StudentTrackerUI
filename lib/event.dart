import 'package:latlong2/latlong.dart';

class Event {
  late String eventName;
  late String collegeName;
  DateTime? startDate;
  DateTime? endDate;
  late List<LatLng> venues;

  Event({
    required this.eventName,
    required this.collegeName,
    this.startDate,
    this.endDate,
    required this.venues,
  });
}

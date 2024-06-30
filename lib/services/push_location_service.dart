import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/services/location_service.dart';
import 'package:ui/services/shared_service.dart';

class PushLocationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {

    await _firebaseMessaging.requestPermission();
    String? fcmToken = await _firebaseMessaging.getToken();
    SharedService.UpdateFCM(fcmToken!);
    print(fcmToken);
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sapId = prefs.getString("sapId");
    String? eventId = prefs.getString("eventId");

    LocationService.getPosition(sapId!, eventId!);
  }


}


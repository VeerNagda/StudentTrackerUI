import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:ui/services/location_service.dart';
import 'package:ui/services/shared_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: false, autoStart: false),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsBackgroundService();
  }

  service.on('setData').listen((event) {
    SharedService.sapId = event?["sap"];
    SharedService.eventId = event?["event_id"];
    SharedService.eventEndTime = event?["event_end_time"];
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: "title", content: "content"); //TODO pari add info
    }
    await LocationService.getPosition();

    if (DateTime.now() == DateTime.now()) {
      service.stopSelf();
    }
    service.invoke('update');
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

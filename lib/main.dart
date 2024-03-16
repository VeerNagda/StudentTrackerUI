import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/routes/routes.dart';
import 'package:ui/services/background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Some web specific code there
  } else if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    // Initialize services
    await handlePermissions();
    await initializeService();

    // Handle permissions
  }

  runApp(const MyApp());
}

// Function to handle permissions
Future<void> handlePermissions() async {
  // Request permissions
  if (!await Permission.location.isGranted) {
    await Permission.location.request();
  }
  if (!await Permission.locationAlways.isGranted) {
    await Permission.locationAlways.request();
  }
  if (!await Permission.camera.isGranted) {
    await Permission.camera.request();
  }
  if (!await Permission.notification.isGranted) {
    await Permission.notification.request();
  }
  if (!await Permission.storage.isGranted) {
    await Permission.storage.request();
  }
  if (!await Permission.manageExternalStorage.isGranted) {
    await Permission.manageExternalStorage.request();
  }

  if (await Permission.location.isGranted &&
      await Permission.locationAlways.isGranted &&
      await Permission.camera.isGranted &&
      await Permission.notification.isGranted &&
      await Permission.storage.isGranted
  ) {
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }
    return;
  } else {
    handlePermissions();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DependencyInjection.init();
    return MaterialApp.router(
      routerConfig: RouteConfig.returnRouter(),
    );
  }
}

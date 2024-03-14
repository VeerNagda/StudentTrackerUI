import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/routes/routes.dart';
import 'package:ui/services/background.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Some web specific code there
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    await Permission.notification.isDenied.then((value) => {if(value){Permission.notification.request()}});
    await Permission.camera.isDenied.then((value) => {if(value){Permission.camera.request()}});
    //await Permission.audio.isDenied.then((value) => {if(value){Permission.audio.request()}});
    await Permission.location.isDenied.then((value) => {if(value){Permission.location.request()}});
    await Permission.locationAlways.isDenied.then((value) => {if(value){Permission.locationAlways.request()}});
    await Permission.ignoreBatteryOptimizations.isDenied.then((value) => {if(value){Permission.ignoreBatteryOptimizations.request()}});
    await initializeService();
  }


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    //DependencyInjection.init();
    return MaterialApp.router(
      routerConfig: RouteConfig.returnRouter(),
    );
  }
}

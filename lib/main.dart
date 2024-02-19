import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/routes/routes.dart';
import 'package:ui/services/background.dart';
import 'package:ui/services/network_service.dart';
import 'package:ui/services/shared_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) => {if(value){Permission.notification.request()}});
  await Permission.locationWhenInUse.isDenied.then((value) => {if(value){Permission.locationWhenInUse.request()}});
  await initializeService();
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

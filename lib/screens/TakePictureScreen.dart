import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/services/api_service.dart';

import '../services/shared_service.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late final CameraController _controller;
  late Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    initCamera();
    FlutterBackgroundService().invoke("stopService");
  }

  _checkPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      PermissionStatus permissionLocationStatus =
          await Permission.locationAlways.request();
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      if (permissionStatus != PermissionStatus.granted &&
          permissionLocationStatus != PermissionStatus.granted) {
        // Permission was denied
        // You may want to disable functionality that depends on the camera permission.
      }
    }
  }

  void initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );
    setState(() {});
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller.value.isInitialized) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  top: 100, // Adjust the Y position as needed
                  left: 50, // Adjust the X position as needed
                  child: Container(
                    width: 210.0, // Adjust the size of the square as needed
                    height: 210.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;
            int response = await APIService.doMultipartImagePost(
                path: "/user/event/verify-user", image: image);
            if (response == 200) {
              FlutterBackgroundService().startService();
              Map<String, dynamic> data = {
                "sap": SharedService.sapId,
                "event_id": SharedService.eventId,
                "event_end_time": SharedService.eventEndTime,
              };
              FlutterBackgroundService().invoke("setData", data);
              if (kDebugMode) {
                print("sent data");
              }
            }
            if (mounted) {
              context.goNamed("home");
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

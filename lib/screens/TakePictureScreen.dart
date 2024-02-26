import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/services/api_service.dart';

import '../services/shared_service.dart';


// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late final CameraController _controller;
  late Future<void>? _initializeControllerFuture;
  late CameraDescription? camera;

  late String text = "";

  @override
  void initState() {
    super.initState();
    initCamera();
    FlutterBackgroundService().invoke("stopService");
  }

  void initCamera() async {
    await availableCameras().then((value) => {
          camera = value[1],
          _controller = CameraController(
            // Get a specific camera from the list of available cameras.
            camera!,
            // Define the resolution to use.
            ResolutionPreset.medium,
          ),
          // Next, initialize the controller. This returns a Future.
        });
    setState(() {});
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              camera != null) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;
            int response = await APIService.doMultipartImagePost(path: "/user/event/verify-user", image: image);
            if(response == 200){




              FlutterBackgroundService().startService();

              Map<String, dynamic> data = {
                "sap": SharedService.sapId,
                "event_id": SharedService.eventId,
                "event_end_time": SharedService.eventEndTime,
              };
              FlutterBackgroundService().invoke("setData", data);
              print("sent data");

            }
            // If the picture was taken, display it on a new screen.
            if(mounted){
              context.goNamed("home");
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
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

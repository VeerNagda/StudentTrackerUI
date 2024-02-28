import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/background.dart';

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
  static late double xCrop;
  static late double yCrop;

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
      if (permissionStatus != PermissionStatus.granted) {
        // Permission was denied
        // You may want to disable functionality that depends on the camera permission.
      }
    }
  }

  _cropImage(XFile image) async {
    File imageFile = File(image.path);

    // Read the image bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Decode the image bytes
    img.Image? capturedImage = img.decodeImage(Uint8List.fromList(imageBytes));

    // Calculate crop dimensions (you need to define your own values)
    double doubleLeft = xCrop; // Define your cropping values
    double doubleTop = yCrop;
    double doubleWidth = 210;
    double doubleHeight = 210;

    int newLeft = (doubleLeft * capturedImage!.width).toInt();
    int newTop = (doubleTop * capturedImage.height).toInt();
    int newWidth = (doubleWidth * capturedImage.width).toInt();
    int newHeight = (doubleHeight * capturedImage.height).toInt();

    // Crop the image
    img.Image croppedImage = img.copyCrop(
      capturedImage,
      newLeft,
      newTop,
      newWidth,
      newHeight,
    );

    // Save the cropped image to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/cropped_image.jpg';

    File croppedFile = File(filePath);
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

    // Convert the cropped file back to XFile
    return XFile(filePath);
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
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.blue
                        .withOpacity(0.5), // Adjust opacity and color as needed
                  ),
                ),
                ClipRect(
                  clipper: MyClip(),
                  child: CameraPreview(_controller),
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
            XFile rawImage = await _controller.takePicture();
            final image = await _cropImage(rawImage);
            if (!mounted) return;
            int response = await APIService.doMultipartImagePost(
                path: "/user/event/verify-user", image: rawImage);
            if (response == 200) {
              /**/
              FlutterBackgroundService().startService();


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

/*// A widget that displays the picture taken by the user.
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
}*/

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Random random = Random();
    TakePictureScreenState.yCrop =
        55 + random.nextDouble() * 255; // Adjust the Y position as needed
    TakePictureScreenState.xCrop =
        5 + random.nextDouble() * 195; // Adjust the X position as needed

    return Rect.fromLTWH(
        TakePictureScreenState.xCrop, TakePictureScreenState.yCrop, 210, 210);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}

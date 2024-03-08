import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/services/api_service.dart';
import 'package:image/image.dart' as img;

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

  Future<XFile> cropImage(XFile imageFile) async {
    // Load the image file
    final data = await imageFile.readAsBytes();
    final image = img.decodeImage(data);

    // Calculate the cropping rectangle based on the clip area
    final left = xCrop.toInt();
    final top = yCrop.toInt();
    const width = 240; // Width of the clip area
    const height = 240; // Height of the clip area

    // Create a temporary directory to save the cropped image
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/cropped_image.jpg');

    // Crop the image using the calculated rectangle and save it to the temporary file
    final croppedImage = img.copyCrop(image!, left, top, width, height);
    await tempFile
        .writeAsBytes(Uint8List.fromList(img.encodeJpg(croppedImage)));

    // Return the XFile of the cropped image
    return XFile(tempFile.path);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (!_controller.value.isInitialized) {
            return const Card(child: Text('No Camera to Preview'));
          }
          var tmp = MediaQuery.of(context).size;
          final screenH = max(tmp.height, tmp.width);
          final screenW = min(tmp.height, tmp.width);
          tmp = _controller.value.previewSize!;
          final previewH = max(tmp.height, tmp.width);
          final previewW = min(tmp.height, tmp.width);
          final screenRatio = screenH / screenW;
          final previewRatio = previewH / previewW;
          if (snapshot.connectionState == ConnectionState.done &&
              _controller.value.isInitialized && !isLoading) {
            return Stack(
              children: [
                /*Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.blue
                        .withOpacity(0.5), // Adjust opacity and color as needed
                  ),
                ),*/
                ClipRect(
                  clipper: MyClip(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: OverflowBox(
                      maxHeight: screenRatio > previewRatio
                          ? screenH
                          : screenW / previewW * previewH,
                      maxWidth: screenRatio > previewRatio
                          ? screenH / previewH * previewW
                          : screenW,
                      child: CameraPreview(
                        _controller,
                      ),
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
          setState(() {
            isLoading = true;
          });
          try {
            await _initializeControllerFuture;
            XFile rawImage = await _controller.takePicture();

            XFile croppedImage = await cropImage(rawImage);
            if (!mounted) return;
            int response = await APIService.doMultipartImagePost(
                path: "/user/event/verify-user", image: croppedImage);
            if (response == 200) {
              /**/
              FlutterBackgroundService().startService();
              setState(() {
                isLoading = false;
              });
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

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Random random = Random();
    /*maxHeight: screenRatio > previewRatio
        ? screenH
        : screenW / previewW * previewH;
    maxWidth: screenRatio > previewRatio
    ? screenH / previewH * previewW
        : screenW;
    double maxHeight= screenRatio > previewRatio
        ? screenH
        : screenW / previewW * previewH;
    double maxWidth= screenRatio > previewRatio
        ? screenH / previewH * previewW
        : screenW;
    TakePictureScreenState.yCrop =
        10 + random.nextDouble() * maxHeight; // Adjust the Y position as needed
    TakePictureScreenState.xCrop =
        5 + random.nextDouble() * maxWidth; // Adjust the X position as needed*/
    TakePictureScreenState.yCrop =
        55 + random.nextDouble() * 350; // Adjust the Y position as needed
    TakePictureScreenState.xCrop =
        5 + random.nextDouble() * 110; // Adjust the X position as needed

    return Rect.fromLTWH(
        TakePictureScreenState.xCrop, TakePictureScreenState.yCrop, 240, 240);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/services/api_service.dart';

class Selfie extends StatefulWidget {
  const Selfie({super.key});

  @override
  _SelfieState createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {
  late CameraController _controller;
  late Future<void>? _initializeControllerFuture;
  late CameraDescription? camera;
  late String imagePath = "";

  @override
  void initState() {
    super.initState();
    initCamera();
    FlutterBackgroundService().invoke("stopService");
  }

  void initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    camera = frontCamera;
    _controller = CameraController(
      camera!,
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
      appBar: AppBar(title: const Text('Profile Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              camera != null) {
            return CameraPreview(_controller);
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
                path: "/user/user-image", image: image, sendLoc: false);
            if (response == 200 && context.mounted && context.canPop()) {
              context.pop();
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

/*  void _navigateToProfileScreen(BuildContext context, String imagePath) {
    context.pop(imagePath);
  }*/
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kumpulin/screen/confirm_photo/confirm_photo_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initialize;

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initialize = _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _initialize,
      builder: (contex, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Container(
              width: mediaQuery.width,
              color: Colors.black,
              child: Column(
                children: [
                  CameraPreview(_cameraController),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await _initialize;
                          final image = await _cameraController.takePicture();
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ConfrimPhotoScreen(
                                imagePath: image.path,
                              ),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

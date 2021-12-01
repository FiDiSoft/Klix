import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kumpulin/screen/confirm_photo/confirm_photo_screen.dart';
import 'package:location/location.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initialize;
  // late LocationData _locationData;
  late Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Future<void> _initializeCamera() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.veryHigh);
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
      builder: (context, snapshot) {
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
                          await location.changeSettings(
                              accuracy: LocationAccuracy.high);
                          final image = await _cameraController.takePicture();
                          final locationData = await location.getLocation();
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConfirmPhotoScreen(
                                imagePath: image.path,
                                locationData: locationData,
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

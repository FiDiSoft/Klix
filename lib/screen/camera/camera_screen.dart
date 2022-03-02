import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumpulin/screen/confirm_photo/confirm_photo_screen.dart';
import 'package:location/location.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.user}) : super(key: key);
  final User user;

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
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
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
    Size size = MediaQuery.of(context).size;

    Future<void> _sendImage() async {
      try {
        await _initialize;
        await location.changeSettings(accuracy: LocationAccuracy.high);
        final image = await _cameraController.takePicture();
        final locationData = await location.getLocation();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmPhotoScreen(
              user: widget.user,
              imagePath: image.path,
              locationData: locationData,
            ),
          ),
        );
      } catch (e) {
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          padding: EdgeInsets.all(20),
          content: Text(
            'Please re-capture image',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return FutureBuilder(
      future: _initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return OrientationBuilder(builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
            return Scaffold(
              body: Container(
                width: size.width,
                height: size.height,
                color: Colors.black,
                child: Stack(
                  children: [
                    Positioned(
                      child: CameraPreview(_cameraController),
                    ),
                    Align(
                      alignment: isLandscape
                          ? Alignment.centerRight
                          : Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: _sendImage,
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(
                            bottom: isLandscape ? 0 : 30,
                            right: isLandscape ? 30 : 0,
                          ),
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
          });
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

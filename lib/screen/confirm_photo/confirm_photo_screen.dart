import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/screen/camera/camera_screen.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:location/location.dart';

class ConfirmPhotoScreen extends StatefulWidget {
  final String imagePath;
  final LocationData locationData;

  const ConfirmPhotoScreen(
      {Key? key, required this.imagePath, required this.locationData})
      : super(key: key);
  @override
  State<ConfirmPhotoScreen> createState() => _ConfirmPhotoScreenState();
}

class _ConfirmPhotoScreenState extends State<ConfirmPhotoScreen> {
  TextEditingController descController = TextEditingController(text: '');

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(widget.imagePath),
            ),
            Container(
              width: mediaQuery.width,
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keterangan',
                    style: labelTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'type something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 5,
                    controller: descController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () async {
                      final imgPODO = Img(
                          img: widget.imagePath,
                          longitude: widget.locationData.longitude.toString(),
                          latitude: widget.locationData.latitude.toString(),
                          desc: descController.text);

                      await ImgDatabase.instance.addImg(imgPODO);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: BuildButton(
                      btnColor: primaryColor,
                      btnBorder: Border.all(color: primaryColor, width: 1),
                      btnText: 'Simpan',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ),
                      );
                    },
                    child: BuildButton(
                      btnColor: whiteBackground,
                      btnBorder: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                      btnText: 'Hapus',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

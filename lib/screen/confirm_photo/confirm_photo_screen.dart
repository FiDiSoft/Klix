import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/constant/date_now.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  Future<void> addDataToDatabase() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    var randomNumber = Random().nextInt(999999) + 1000000;
    final dir = await getExternalStorageDirectory();
    String formatNameImage = "img-$randomNumber.jpg";
    final imgPath = "${dir?.path}/images/$formatNameImage";
    File(path.join(imgPath))
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    final imgPODO = Img(
      img: formatNameImage,
      imgPath: imgPath,
      longitude: widget.locationData.longitude.toString(),
      latitude: widget.locationData.latitude.toString(),
      desc: descController.text,
      timeStamps: DateTime.now(),
    );

    await ImgDatabase.instance.store(imgPODO);
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Container(
                  width: mediaQuery.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi gambar',
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
                          hintText: 'Deskripsi gambar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        maxLines: 5,
                        maxLength: 1000,
                        controller: descController,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () async {
                  await addDataToDatabase();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                label: const Text('Simpan'),
                backgroundColor: primaryColor,
                icon: const Icon(Icons.save),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text('Hapus'),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ));
  }
}

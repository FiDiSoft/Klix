import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ConfirmPhotoScreen extends StatefulWidget {
  final String imagePath;
  final LocationData locationData;
  final User user;

  const ConfirmPhotoScreen(
      {Key? key,
      required this.imagePath,
      required this.locationData,
      required this.user})
      : super(key: key);
  @override
  State<ConfirmPhotoScreen> createState() => _ConfirmPhotoScreenState();
}

class _ConfirmPhotoScreenState extends State<ConfirmPhotoScreen> {
  TextEditingController descController = TextEditingController(text: '');
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> addDataToDatabase() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final dateNow = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
    final username = widget.user.displayName?.replaceAll(RegExp(r"\s+"), "-");
    final dir = await getExternalStorageDirectory();
    // TODO : Format file : img-username-tanggal-package-1.jpg
    String formatNameImage = "img-$username-$dateNow.jpg";
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
                        height: 400,
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
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                    onPressed: () async {
                      await addDataToDatabase();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }, 
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Simpan', style: GoogleFonts.poppins(
                        color: Colors.white
                      ),),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Hapus', style: GoogleFonts.poppins(
                        color: Colors.white
                      ),),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}

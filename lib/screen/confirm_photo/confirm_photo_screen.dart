import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/screen/home/home_page.dart';
import 'package:kumpulin/widgets/build_button.dart';

class ConfrimPhotoScreen extends StatefulWidget {
  final String imagePath;
  const ConfrimPhotoScreen({Key? key, required this.imagePath})
      : super(key: key);
  @override
  State<ConfrimPhotoScreen> createState() => _ConfrimPhotoScreenState();
}

class _ConfrimPhotoScreenState extends State<ConfrimPhotoScreen> {
  TextEditingController keteranganController = TextEditingController(text: '');

  @override
  void dispose() {
    keteranganController.dispose();
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
                      hintText: 'Isi keterangan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 5,
                    controller: keteranganController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
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
                      Navigator.of(context).pop();
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

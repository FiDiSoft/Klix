import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/convert_excel.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/models/send_email.dart';
import 'package:kumpulin/models/validators.dart';
import 'package:kumpulin/widgets/build_button.dart';

class SendPage extends StatefulWidget {
  const SendPage({
    Key? key,
    required this.user,
    required this.listImages,
  }) : super(key: key);

  final User user;
  final List<Img> listImages;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late TextEditingController emailController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'Halaman Kirim',
          style: headingStyle.copyWith(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: emailController,
                      validator: (email) =>
                          Validators.validateEmail(email: email.toString()),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan email penerima',
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20.0,
                    thickness: 1,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String dateNow =
                            DateFormat("yyyy-MM-dd").format(DateTime.now());
                        String? username = widget.user.displayName
                            ?.replaceAll(RegExp(r"\s+"), "-");
                        String imagesZipFilename =
                            "images-$username-$dateNow.zip";
                        String excellFileName =
                            "report-$username-$dateNow.xlsx";
                        final _convertExcel =
                            ConvertExcel(excellFileName, imagesZipFilename);
                        _convertExcel.generateExcel(
                            user: widget.user, listImages: widget.listImages);
                        sendEmail(
                          user: widget.user,
                          emailRecipient: emailController.text,
                          excellFileName: imagesZipFilename,
                          imagesZipFileName: excellFileName,
                        );

                        emailController.text = '';

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(20),
                            content: Text(
                              'Data berhasil terkirim!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: BuildButton(
                      btnColor: primaryColor,
                      btnBorder: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                      btnText: 'Kirim File',
                      btnTextStyle: bodyTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20.0,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
            sliver: SliverGrid(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                Img image = widget.listImages[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      File(image.imgPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }, childCount: widget.listImages.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}

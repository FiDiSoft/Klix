import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/convert_excel.dart';
import 'package:kumpulin/models/send_email.dart';
import 'package:kumpulin/widgets/build_button.dart';

class SendPage extends StatefulWidget {
  const SendPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late TextEditingController emailController = TextEditingController(text: '');

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan email penerima',
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 50.0,
                thickness: 1,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  final _convertExcel = ConvertExcel();
                  _convertExcel.generateExcel(user: widget.user);
                  sendEmail(
                      user: widget.user, emailRecipient: emailController.text);

                  emailController.text = '';

                  Navigator.pop(context);

                  const snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(20),
                    content: Text(
                      'Data berhasil terkirim!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    duration: Duration(seconds: 2),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: BuildButton(
                  btnColor: primaryColor,
                  btnBorder: Border.all(
                    color: primaryColor,
                    width: 1,
                  ),
                  btnText: 'Kirim File',
                  btnTextStyle: bodyTextStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

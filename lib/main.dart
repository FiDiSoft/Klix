import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:kumpulin/pages/login_page.dart';
=======
import 'package:flutter/widgets.dart';
import 'package:kumpulin/screen/home/home_page.dart';
>>>>>>> 86430b861f5bdf15bf157a1da8719a142bb72223

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}

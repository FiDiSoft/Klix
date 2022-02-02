import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kumpulin/auth.dart';
import 'package:kumpulin/models/google_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return StreamProvider.value(
              value: userStream,
              initialData: null,
              child: const Auth(),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/camera.json', width: 250, height: 250),
            Text("Kumpul-in",
                style: headingStyle.copyWith(
                    color: primaryColor, fontWeight: FontWeight.bold)),
            Text('Grab Picture App',
                style: bodyTextStyle.copyWith(
                    color: secondaryColor, fontSize: 24)),
          ],
        ),
      ),
    ));
  }
}

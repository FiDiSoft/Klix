import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kumpulin/constant/theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

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

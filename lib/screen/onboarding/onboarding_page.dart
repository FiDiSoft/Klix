
import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/google_auth.dart';
import 'package:lottie/lottie.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                Text("KLIX",
                style: headingStyle.copyWith(
                    color: primaryColor, fontWeight: FontWeight.bold)),
                Text('Capture and Save your Location',
                    style: bodyTextStyle.copyWith(
                        color: accentColor, fontSize: 16)),
                const SizedBox(height: 70),
                Image.asset('assets/logo-app.png', width: 250, height: 250,),
                // Lottie.asset('assets/point_marker.json', width: 250, height: 250),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  height: 59,
                  width: 238,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google.png',
                          width: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sign In',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 59,
                  width: 238,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google.png',
                          width: 22,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign Up ',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: baseTextColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

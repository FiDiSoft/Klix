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
                Text("Kumpul-in",
                    style: headingStyle.copyWith(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                Text('Ambil dan Abadikan Fotomu',
                    style: bodyTextStyle.copyWith(
                        color: secondaryColor, fontSize: 16)),
                const SizedBox(height: 70),
                Lottie.asset('assets/camera.json', width: 250, height: 250),
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
                          'Masuk dengan Google',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: Colors.white),
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
                      color: Colors.white,
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
                          'Daftar dengan Google',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: primaryColor),
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

import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/screen/home/home_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                Text("Kumpul-in",
                    style: headingStyle.copyWith(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                Text('Grab Picture App',
                    style: bodyTextStyle.copyWith(
                        color: secondaryColor, fontSize: 24)),
                SizedBox(height: 130),
                Image.asset(
                  'assets/logo.png',
                  width: 300,
                ),
                SizedBox(
                  height: 130,
                ),
                Container(
                  height: 59,
                  width: 238,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Image.asset(
                          'assets/google.png',
                          width: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Login with Google',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: Colors.white),
                        )
                      ])),
                ),
                SizedBox(height: 20),
                Container(
                  height: 59,
                  width: 238,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {},
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Image.asset(
                          'assets/google.png',
                          width: 22,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Register with Google',
                          style: bodyTextStyle.copyWith(
                              fontSize: 14, color: primaryColor),
                        )
                      ])),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

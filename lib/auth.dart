import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumpulin/screen/home/home_page.dart';
import 'package:kumpulin/screen/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return (user != null)
        ? HomePage(
            user: user,
          )
        : const OnBoardingPage();
  }
}
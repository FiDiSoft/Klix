import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kumpulin/screen/home/home_page.dart';
import 'package:kumpulin/screen/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';

import 'models/google_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Implement named route for simplify passing data between screen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamProvider.value(
        value: GoogleAuth.userStream,
        initialData: null,
        child: const Auth(),
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // User? user = Provider.of<User?>(context);
    // return (user != null) ? const HomePage() : const OnBoardingPage();
    return const HomePage();
  }
}

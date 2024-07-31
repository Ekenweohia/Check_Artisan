import 'package:flutter/material.dart';
import 'package:check_artisan/loginsignupclient/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:check_artisan/loginsignupclient/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
  );

  await initializeApp();

  runApp(const MyApp());
}

Future<void> initializeApp() async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Artisan',
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const SplashScreen(),
    );
  }
}

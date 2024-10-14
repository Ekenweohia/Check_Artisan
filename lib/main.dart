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
        primaryColor: const Color(0xFF004D40), // Base primary color for the app
        scaffoldBackgroundColor: Colors.white, // Ensure all pages have a white background
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFF004D40)), // Use the generated MaterialColor
        ).copyWith(
          secondary: const Color(0xFF004D40), // Accent color for interactive elements
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xF2004D40)), // Use the specific color when focused
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

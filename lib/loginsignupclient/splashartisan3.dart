import 'package:check_artisan/RegistrationArtisan/register_artisan.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class SplashArtisan3 extends StatefulWidget {
  const SplashArtisan3({Key? key}) : super(key: key);

  @override
  SplashArtisan3State createState() => SplashArtisan3State();
}

class SplashArtisan3State extends State<SplashArtisan3> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      CheckartisanNavigator.pushReplacement(
        context,
        const RegisterArtisan(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/icons/Splash 11.png', // Change this to your actual background image path
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/icons/Rectangle.png',
                  width: 245,
                  height: 248,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Deliver your services promptly or by appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat-Light.ttf',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                // White indicators
                const Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey, // White indicator
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey, // White indicator
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white, // White indicator
                      ),
                    ],
                  ),
                ),
                // Sign Up button
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Rounded corners
                      ),
                      side: const BorderSide(
                          color: Color(0xFF2C6B58),
                          width: 1), // Optional border
                    ),
                    onPressed: () {
                      CheckartisanNavigator.pushReplacement(
                        context,
                        const RegisterArtisan(),
                      );
                    },
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C6B58), // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

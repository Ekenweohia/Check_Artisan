import 'package:check_artisan/RegistrationArtisan/register_artisan.dart';
import 'package:check_artisan/loginsignupclient/splashartisan3.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class SplashArtisan2 extends StatefulWidget {
  const SplashArtisan2({Key? key}) : super(key: key);

  @override
  SplashArtisan2State createState() => SplashArtisan2State();
}

class SplashArtisan2State extends State<SplashArtisan2> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      CheckartisanNavigator.pushReplacement(
        context,
        const SplashArtisan3(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icons/Splash 11.png',
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
                    'Secure top-notch artisans to address your needs conveniently from your own location.',
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                // Updated SKIP button with specific requirements
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: SizedBox(
                    width: 150, // Fixed width of 150px
                    height: 40, // Fixed height of 40px
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero, // Remove padding to centralize text
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5), // Border radius 5px for the top-left corner
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF2C6B58), // Border color
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        CheckartisanNavigator.pushReplacement(
                          context,
                          const RegisterArtisan(),
                        );
                      },
                      child: const Text(
                        'SKIP',
                        textAlign: TextAlign.center, // Ensure text is centered
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C6B58), // Text color
                        ),
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

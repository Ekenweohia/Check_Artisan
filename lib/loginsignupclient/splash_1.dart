import 'package:check_artisan/RegistrationClient/register_client.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:check_artisan/loginsignupclient/splash_2.dart';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  Splash1State createState() => Splash1State();
}

class Splash1State extends State<Splash1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      CheckartisanNavigator.pushReplacement(
        context,
        const Splash2(),
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
                    'Quickly and effortlessly locate professionals to meet your domestic requirements.',
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
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      side:
                          const BorderSide(color: Color(0xFF2C6B58), width: 1),
                    ),
                    onPressed: () {
                      CheckartisanNavigator.pushReplacement(
                        context,
                        const RegisterClient(),
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

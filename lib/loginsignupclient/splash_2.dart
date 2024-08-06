import 'package:check_artisan/loginsignupclient/splash_3.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class Splash2 extends StatelessWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/icons/track.png',
                  width: 200,
                  height: 200,
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
                      color: Color(0xFF2C6B58),
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
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFF2C6B58),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height / 2 + 200,
            child: GestureDetector(
              onTap: () {
                CheckartisanNavigator.push(context, const Splash3());
              },
              child: Image.asset(
                'assets/Buttons/Group 1.png',
                width: 114,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

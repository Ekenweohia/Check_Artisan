import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:check_artisan/loginsignupclient/splash_2.dart';

class Splash1 extends StatelessWidget {
  const Splash1({Key? key}) : super(key: key);

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
                  'assets/icons/bro.png',
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
                        backgroundColor: Color(0xFF2C6B58),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
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
                CheckartisanNavigator.push(
                  context,
                  const Splash2(),
                );
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

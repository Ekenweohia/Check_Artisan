import 'package:check_artisan/loginsignupclient/splash_1.dart';
import 'package:check_artisan/loginsignupclient/splashartisan1.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8, // Set image opacity to 80%
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/reg screen.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: const Color(0xF2004D40),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 400,
                ),
                const Spacer(),
                Container(
                  width: 209, // Set fixed width of 209px
                  height: 37, // Set fixed height of 37px
                  margin: const EdgeInsets.only(bottom: 17), // Gap of 10px between buttons
                  child: ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(context, const Splash1());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xF2004D40),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30), // Padding inside the button
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0), // Border radius 5px top-left
                          topRight: Radius.circular(5.0), 
                          bottomLeft: Radius.circular(5.0), 
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('SIGN UP AS A CLIENT'),
                  ),
                ),
                Container(
                  width: 209, // Set fixed width of 209px
                  height: 37, // Set fixed height of 37px
                  margin: const EdgeInsets.only(bottom: 10), // Gap of 10px between buttons
                  child: ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const SplashArtisan1());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xF2004D40),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30), // Padding inside the button
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0), // Border radius 5px top-left
                          topRight: Radius.circular(5.0), 
                          bottomLeft: Radius.circular(5.0), 
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('SIGN UP AS AN ARTISAN'),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

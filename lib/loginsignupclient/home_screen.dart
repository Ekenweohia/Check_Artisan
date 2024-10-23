import 'package:check_artisan/loginsignupclient/splash_1.dart';
import 'package:check_artisan/loginsignupclient/splashartisan1.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Opacity
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
          // Transparent Overlay
          Container(
            color: const Color(0xF2004D40),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Responsive Logo
                Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 400.w, // Responsive width
                ),
                const Spacer(),
                // SIGN UP AS A CLIENT Button
                Container(
                  width: 209.w, // Responsive width
                  height: 37.h, // Responsive height
                  margin: EdgeInsets.only(bottom: 17.h), // Responsive margin
                  child: ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(context, const Splash1());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xF2004D40),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 30.w), // Responsive padding
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0), // Border radius
                        ),
                      ),
                      textStyle: TextStyle(
                        fontSize: 12.sp, // Responsive font size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('SIGN UP AS A CLIENT'),
                  ),
                ),
                // SIGN UP AS AN ARTISAN Button
                Container(
                  width: 209.w, // Responsive width
                  height: 37.h, // Responsive height
                  margin: EdgeInsets.only(bottom: 10.h), // Responsive margin
                  child: ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const SplashArtisan1());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xF2004D40),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 30.w), // Responsive padding
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0), // Border radius
                        ),
                      ),
                      textStyle: TextStyle(
                        fontSize: 12.sp, // Responsive font size
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

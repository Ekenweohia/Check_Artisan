import 'package:check_artisan/RegistrationArtisan/email_artisan.dart';
import 'package:check_artisan/RegistrationArtisan/phone_artisan.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class RegisterArtisan extends StatelessWidget {
  const RegisterArtisan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/reg screen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xF2004D40),
          ),
          Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Center alignment for text and buttons
                      children: [
                        const Text(
                          'Welcome to CheckArtisan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "CheckArtisan supports quality tradespersons around Nigeria."
                            "Our application process is strict and only those who meet our high standards are accepted.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Montserrat-Light.ttf'),
                          ),
                        ),
                        const SizedBox(height: 40), // Increased spacing to move buttons up
                        // Centering the buttons and making them the same size
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250, // Fixed width to make both buttons the same size
                              child: ElevatedButton(
                                onPressed: () {
                                  CheckartisanNavigator.push(
                                      context, const EmailArtisan());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004D40),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0), // Consistent vertical padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('HAVE AN EMAIL?'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 250, // Fixed width to make both buttons the same size
                              child: ElevatedButton(
                                onPressed: () {
                                  CheckartisanNavigator.push(
                                      context, const PhoneArtisan());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004D40),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0), // Consistent vertical padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('USE MY PHONE NUMBER'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:check_artisan/RegistrationClient/email_client.dart';
import 'package:check_artisan/RegistrationClient/phone_client.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class RegisterClient extends StatelessWidget {
  const RegisterClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
                  width: screenSize.width * 0.5,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 8),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Need a skilled hand for your next project? Look no further! With Check Artisan,"
                            "connecting with reliable artisans has never been easier. Whether it's home repairs,"
                            "renovations, or catering services, our platform connects you with vetted professionals who are ready to get the job done.\n\nSimply browse, book, "
                            "and relax as our network of skilled workmen brings your projects to life. Say goodbye to the hassle of searching for trustworthy contractors – we've got you covered.\n\nWelcome aboard, and let's get to work!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat-SemiBold.ttf',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            CheckartisanNavigator.push(
                                context, const EmailClient());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D40),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.08,
                              vertical: screenSize.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            textStyle: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('HAVE AN EMAIL?'),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            CheckartisanNavigator.push(
                                context, const PhoneClient());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D40),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.08,
                              vertical: screenSize.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            textStyle: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('USE MY PHONE NUMBER'),
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

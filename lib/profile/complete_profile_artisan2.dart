import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/id_verification.dart';
import 'package:check_artisan/profile/complete_profile_artisan.dart';
import 'package:flutter/material.dart';

class CompleteProfile2 extends StatefulWidget {
  const CompleteProfile2({Key? key}) : super(key: key);

  @override
  CompleteProfile2State createState() => CompleteProfile2State();
}

class CompleteProfile2State extends State<CompleteProfile2> {
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  bool _textAlert = false;
  bool _emailAlert = false;
  bool _newsletterSubscription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Give us a brief description of your business',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _businessDescriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'How do you prefer us contacting you?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Text Alert (SMS)'),
                value: _textAlert,
                onChanged: (bool value) {
                  setState(() {
                    _textAlert = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Email Alert'),
                value: _emailAlert,
                onChanged: (bool value) {
                  setState(() {
                    _emailAlert = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Love to get tips on how to get the right job?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SwitchListTile(
                title: const Text('Subscribe to our newsletter'),
                value: _newsletterSubscription,
                onChanged: (bool value) {
                  setState(() {
                    _newsletterSubscription = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const CompleteProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                        side: const BorderSide(color: Color(0xFF004D40)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const IDVerification());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

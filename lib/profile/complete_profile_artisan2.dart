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
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
                "",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Business description TextField with rounded edges
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2), // subtle shadow
                    ),
                  ],
                ),
                child: TextField(
                  controller: _businessDescriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    hintText: 'Enter a brief description of your business',
                    filled: true,
                    fillColor: Colors.white,
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

              // Custom Row for Switch with the toggle on the left for SMS
              Row(
                children: [
                  Switch(
                    value: _textAlert,
                    onChanged: (bool value) {
                      setState(() {
                        _textAlert = value;
                      });
                    },
                    activeColor: Colors.teal,
                    inactiveTrackColor:
                        Colors.grey[300], // Visible track when off
                    inactiveThumbColor: Colors.grey, // Visible thumb when off
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Text Alert (SMS)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Custom Row for Email Alert
              Row(
                children: [
                  Switch(
                    value: _emailAlert,
                    onChanged: (bool value) {
                      setState(() {
                        _emailAlert = value;
                      });
                    },
                    activeColor: Colors.teal,
                    inactiveTrackColor:
                        Colors.grey[300], // Visible track when off
                    inactiveThumbColor: Colors.grey, // Visible thumb when off
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Email Alert',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Love to get tips on how to get the right job?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

              // Custom Row for Newsletter Subscription
              Row(
                children: [
                  Switch(
                    value: _newsletterSubscription,
                    onChanged: (bool value) {
                      setState(() {
                        _newsletterSubscription = value;
                      });
                    },
                    activeColor: Colors.teal,
                    inactiveTrackColor:
                        Colors.grey[300], // Visible track when off
                    inactiveThumbColor: Colors.grey, // Visible thumb when off
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Subscribe to our newsletter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Adjusted Buttons: aligned to the right
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to right
                children: [
                  // Previous Button
                  ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const CompleteProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Subtle rounded corners
                        side: const BorderSide(color: Color(0xFF004D40)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 10), // Spacing between buttons

                  // Continue Button
                  ElevatedButton(
                    onPressed: () {
                      CheckartisanNavigator.push(
                          context, const IDVerification());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
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

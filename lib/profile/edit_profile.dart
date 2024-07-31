import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Chimdimma');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Nwobu');
  final TextEditingController _emailController =
      TextEditingController(text: 'chimdimma.nwobu@ecr-ts.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '********');
  final TextEditingController _addressController = TextEditingController(
      text: '74A Road 5, Federal Low-cost Housing Estate Umuahia');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF004D40),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtisanScreen(),
                    ));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_image.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.edit,
                        color: Color(0xFF004D40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _firstNameController, label: 'First Name'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _lastNameController, label: 'Last Name'),
                  const SizedBox(height: 20),
                  CustomTextField(controller: _emailController, label: 'Email'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _addressController, label: 'Address'),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        debugPrint('First Name: ${_firstNameController.text}');
                        debugPrint('Last Name: ${_lastNameController.text}');
                        debugPrint('Email: ${_emailController.text}');
                        debugPrint('Password: ${_passwordController.text}');
                        debugPrint('Address: ${_addressController.text}');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'EDIT PROFILE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

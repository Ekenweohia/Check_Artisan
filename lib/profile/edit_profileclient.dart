import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:check_artisan/profile/edit_profile.dart';

class EditProfileClient extends StatefulWidget {
  const EditProfileClient({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileClientState createState() => _EditProfileClientState();
}

class _EditProfileClientState extends State<EditProfileClient> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 13.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                CheckartisanNavigator.push(context, const ArtisanScreen());
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: screenSize.width * 0.15,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/profile.jpg') as ImageProvider,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            const ProfileFormField(labelText: 'First Name:'),
            SizedBox(height: screenSize.height * 0.03),
            const ProfileFormField(labelText: 'Last Name:'),
            SizedBox(height: screenSize.height * 0.03),
            const ProfileFormField(labelText: 'Email:'),
            SizedBox(height: screenSize.height * 0.02),
            const ProfileFormField(labelText: 'Password:'),
            SizedBox(height: screenSize.height * 0.02),
            const ProfileFormField(labelText: 'Address:'),
            SizedBox(height: screenSize.height * 0.03),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 128,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color(0xFF004D40),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    CheckartisanNavigator.push(context, const EditProfileScreen());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFormField extends StatelessWidget {
  final String labelText;

  const ProfileFormField({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 17.07 / 14,
            letterSpacing: -0.3,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

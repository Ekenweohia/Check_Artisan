import 'package:check_artisan/RegistrationClient/login_client.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/change_password.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:check_artisan/profile/edit_profile.dart';
import 'package:check_artisan/profile/info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 13.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
              onPressed: () {
                CheckartisanNavigator.push(context, const ArtisanScreen());
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.04,
            vertical: screenSize.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenSize.width * 0.15,
              backgroundImage: const AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.04,
                  vertical: screenSize.height * 0.01),
              decoration: BoxDecoration(
                color: const Color(0xFF004D40),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Chimdima C. Nwobu',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            ProfileOption(
              text: 'Edit Profile',
              iconPath: 'assets/Buttons/edit.png',
              onTap: () {
                CheckartisanNavigator.push(context, const EditProfileScreen());
              },
            ),
            SizedBox(height: screenSize.height * 0.03),
            ProfileOption(
              text: 'Change Password',
              iconPath: 'assets/Buttons/password.png',
              onTap: () {
                CheckartisanNavigator.push(
                    context, const ChangePasswordScreen());
              },
            ),
            SizedBox(height: screenSize.height * 0.02),
            ProfileOption(
              text: 'Information',
              iconPath: 'assets/Buttons/info.png',
              onTap: () {
                CheckartisanNavigator.push(context, const InformationScreen());
              },
            ),
            SizedBox(height: screenSize.height * 0.03),
            ProfileOption(
              text: 'Update',
              iconPath: 'assets/Buttons/update.png',
              onTap: () {},
            ),
            SizedBox(height: screenSize.height * 0.03),
            ProfileOption(
              text: 'Log Out',
              iconPath: 'assets/Buttons/logout.png',
              onTap: () {
                CheckartisanNavigator.push(context, const LoginClient());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height * 0.065, // Reduced height
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
                fontSize: screenSize.width * 0.035), // Reduced font size
          ),
          trailing: Image.asset(
            iconPath,
            width: screenSize.width * 0.045, // Reduced icon width
            height: screenSize.width * 0.045, // Reduced icon height
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

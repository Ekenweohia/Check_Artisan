import 'package:check_artisan/RegistrationClient/login_client.dart';
import 'package:check_artisan/profile/change_password.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/settings.dart';
import 'package:flutter/material.dart';
import 'package:check_artisan/Home_Client/homeclient.dart';
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
          padding: const EdgeInsets.only(top: 8.0),
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
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArtisanScreen()),
                );
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
            SizedBox(height: screenSize.height * 0.03),
            ProfileOption(
              text: 'Edit Profile',
              iconPath: 'assets/Buttons/edit.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            SizedBox(height: screenSize.height * 0.03),
            ProfileOption(
              text: 'Change Password',
              iconPath: 'assets/Buttons/password.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
            SizedBox(height: screenSize.height * 0.02),
            ProfileOption(
              text: 'Information',
              iconPath: 'assets/Buttons/info.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformationScreen()),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginClient()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeClient()),
              );
              break;
            case 1:
              // Navigate to Location screen
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              break;
            case 3:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.grey),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build, color: Colors.grey),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFF004D40)),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF004D40),
        unselectedItemColor: Colors.grey,
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
      height: screenSize.height * 0.08,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(fontSize: screenSize.width * 0.04),
          ),
          trailing: Image.asset(iconPath,
              width: screenSize.width * 0.05, height: screenSize.width * 0.05),
          onTap: onTap,
        ),
      ),
    );
  }
}

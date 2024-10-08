import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/profile/profile.dart';
import 'package:check_artisan/profile/settings.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeClient(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  final List<String> iconImages = [
    'assets/icons/home.png',
    'assets/icons/location.png',
    'assets/icons/tools.png',
    'assets/icons/profile.png',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.teal,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        iconImages[0],
                        width: 24,
                        height: 24,
                        color: _currentIndex == 0 ? Colors.teal : Colors.grey,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        iconImages[1],
                        width: 24,
                        height: 24,
                        color: _currentIndex == 1 ? Colors.teal : Colors.grey,
                      ),
                      label: 'Location',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        iconImages[2],
                        width: 24,
                        height: 24,
                        color: _currentIndex == 2 ? Colors.teal : Colors.grey,
                      ),
                      label: 'Tools',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        iconImages[3],
                        width: 24,
                        height: 24,
                        color: _currentIndex == 3 ? Colors.teal : Colors.grey,
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

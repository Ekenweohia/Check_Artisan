import 'package:check_artisan/Artisan_DetailsScreens/artisanlistscreen.dart';
import 'package:check_artisan/Home_Client/tradetype.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/profile.dart';
import 'package:check_artisan/profile/settings.dart';
import 'package:flutter/material.dart';

class HomeClient extends StatelessWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeClientContent(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF004D40)),
            label: '',
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
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF004D40),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomeClientContent extends StatelessWidget {
  const HomeClientContent({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> artisans = const [
    {"icon": Icons.electrical_services, "label": "Electrician"},
    {"icon": Icons.construction, "label": "Welder"},
    {"icon": Icons.directions_car, "label": "Driving"},
    {"icon": Icons.design_services, "label": "Fashion Designer"},
    {"icon": Icons.event, "label": "Event Planner"},
    {"icon": Icons.content_cut, "label": "Hair Stylist"},
    {"icon": Icons.grass, "label": "Gardener"},
    {"icon": Icons.carpenter, "label": "Carpenter"},
    {"icon": Icons.person, "label": "Barber"},
    {"icon": Icons.car_repair, "label": "Auto Mechanic"},
    {"icon": Icons.grass, "label": "Gardener"},
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtisanScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hey Cheemdee!',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, fontFamily: ''),
              ),
              const Text(
                'How can we help you today?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Artisans',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Center(
                child: Text(
                  'Most Rated Artisans',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 4 : 3,
                  childAspectRatio: screenWidth > 600 ? 1.4 : 1.2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: artisans.length,
                itemBuilder: (context, index) {
                  return ArtisanCard(
                    icon: artisans[index]['icon'],
                    label: artisans[index]['label'],
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TradeTypeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
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

class ArtisanCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const ArtisanCard({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ArtisanListScreen(
                title: '$label List',
                artisanType: label,
              );
            },
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF004D40)),
            ),
          ],
        ),
      ),
    );
  }
}

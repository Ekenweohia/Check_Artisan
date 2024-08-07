import 'package:check_artisan/jobs/job_list_screen.dart';
import 'package:check_artisan/jobs/quote_request_screen.dart';
import 'package:check_artisan/jobs/reviews_screen.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/profile.dart';
import 'package:check_artisan/profile/settings.dart';
import 'package:flutter/material.dart';

class ArtisanDashboard extends StatelessWidget {
  const ArtisanDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove the back arrow button
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            onPressed: () {
              CheckartisanNavigator.push(context, const ArtisanScreen());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArtisanDashboard()));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back Artisan,',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/dashboard.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: double.infinity,
                    height: screenSize.height * 0.2,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/profile_placeholder.png'), // Replace with actual image from profile
                          radius: 40,
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Cheemdee',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: buildStarRating(4),
                                ),
                              ],
                            ),
                            const Text(
                              'Event Planners & Caterers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: screenSize.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: screenSize.width > 600 ? 1.2 : 1.5,
                children: [
                  buildCard(context, '0 New Job(s)', Icons.work,
                      'NewJobsScreen', screenSize),
                  buildCard(context, '0 Job Lists', Icons.list,
                      'JobListsScreen', screenSize),
                  buildCard(context, '0 Review(s)', Icons.message,
                      'ReviewsScreen', screenSize),
                  buildCard(context, '0 Quote(s)', Icons.edit, 'QuotesScreen',
                      screenSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildStarRating(int rating) {
    return List<Widget>.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      );
    });
  }

  Widget buildCard(BuildContext context, String title, IconData icon,
      String routeName, Size screenSize) {
    return GestureDetector(
      onTap: () {
        switch (routeName) {
          case 'NewJobsScreen':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtisanDashboard()));
            break;
          case 'JobListsScreen':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const JobListScreen()));
            break;
          case 'ReviewsScreen':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReviewsScreen()));
            break;
          case 'QuotesScreen':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuoteRequestsScreen()));
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: screenSize.width * 0.1),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: screenSize.width * 0.04),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:check_artisan/Artisan_DetailsScreens/artisan_dashboard.dart';
import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/profile.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('MY Jobs',
            style: TextStyle(
              color: Colors.black,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtisanScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          JobCard(
            title: 'Food',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Awaiting Quotes',
            statusColor: Colors.red,
            icon: Icons.list,
          ),
          JobCard(
            title: 'Electrician Work',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Job Completed',
            statusColor: const Color(0xFF004D40),
            icon: Icons.list,
          ),
          JobCard(
            title: 'Plumbering Work',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Awaiting Quotes',
            statusColor: Colors.red,
            icon: Icons.list,
          ),
          JobCard(
            title: 'Fashion Designer',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Awaiting Quotes',
            statusColor: Colors.red,
            icon: Icons.list,
          ),
          JobCard(
            title: 'Food',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Awaiting Quotes',
            statusColor: Colors.red,
            icon: Icons.list,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeClient(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtisanDashboard(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtisanDashboard(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
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
            icon: Icon(Icons.build, color: Color(0xFF004D40)),
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

class JobCard extends StatelessWidget {
  final String title;
  final String jobRef;
  final String postedDate;
  final String status;
  final Color statusColor;
  final IconData icon;

  JobCard({
    required this.title,
    required this.jobRef,
    required this.postedDate,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Job Ref: $jobRef'),
            Text('Posted: $postedDate'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Job Status: $status',
                    style: TextStyle(color: statusColor),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: statusColor, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

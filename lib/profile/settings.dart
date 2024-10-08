import 'package:check_artisan/Artisan_DetailsScreens/artisan_dashboard.dart';
import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/profile.dart' as profile;
import 'package:check_artisan/utils.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentPage = 0;

  final List<Widget> pages = [
    const HomeClient(),
    const ArtisanDashboard(),
    const profile.ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentPage = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MY Jobs',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            onPressed: () {
              CheckartisanNavigator.pushReplacement(
                  context, const ArtisanScreen());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
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
            statusColor: Color(0xFF004D40),
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

  const JobCard({
    Key? key,
    required this.title,
    required this.jobRef,
    required this.postedDate,
    required this.status,
    required this.statusColor,
    required this.icon,
  }) : super(key: key);

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

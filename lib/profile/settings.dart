import 'package:flutter/material.dart';
import 'package:check_artisan/Artisan_DetailsScreens/artisan_dashboard.dart';
import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:check_artisan/profile/profile.dart' as profile;
import 'package:check_artisan/utils.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // Responsive height
        child: Container(
          padding: EdgeInsets.only(
              top: screenHeight * 0.05, bottom: screenHeight * 0.02),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48), // Placeholder for alignment purposes
              Expanded(
                child: Center(
                  child: Text(
                    'MY Jobs',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05, // Responsive font size
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () {
                  CheckartisanNavigator.pushReplacement(
                      context, const ArtisanScreen());
                },
              ),
            ],
          ),
        ),
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
            location: 'Umuahia, Abia State, Nigeria',
            budget: 'Over NGN100,000',
            timing: 'Within a week',
            description: '200 packs of food for an event',
          ),
          JobCard(
            title: 'Electrician Work',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Job Completed',
            statusColor: Color(0xFF004D40),
            icon: Icons.list,
            location: 'Lagos, Nigeria',
            budget: 'NGN50,000 - NGN70,000',
            timing: '2 days',
            description: 'Electrical wiring and socket installations',
          ),
          JobCard(
            title: 'Plumbering Work',
            jobRef: 'SRIZXOMvao',
            postedDate: '2024-04-29 14:04:59',
            status: 'Awaiting Quotes',
            statusColor: Colors.red,
            icon: Icons.menu,
            location: 'Ibadan, Oyo State, Nigeria',
            budget: 'NGN30,000 - NGN40,000',
            timing: '3 days',
            description: 'Fixing of bathroom leakages',
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
  final String location;
  final String budget;
  final String timing;
  final String description;

  const JobCard({
    Key? key,
    required this.title,
    required this.jobRef,
    required this.postedDate,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.location,
    required this.budget,
    required this.timing,
    required this.description,
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
                InkWell(
                  onTap: () {
                    _showJobDetailsDialog(
                      context,
                      title,
                      jobRef,
                      postedDate,
                      location,
                      budget,
                      timing,
                      description,
                    );
                  },
                  child: Icon(icon, color: statusColor, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDetailsDialog(BuildContext context, String title, String jobRef,
      String postedDate, String location, String budget, String timing, String description) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOutBack.transform(animation.value);
        return Transform(
          transform: Matrix4.identity()..scale(curvedValue, curvedValue),
          child: Opacity(
            opacity: animation.value,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Align(
                        alignment: Alignment.center,
                        child: JobDetailsDialog(
                          title: title,
                          jobRef: jobRef,
                          postedDate: postedDate,
                          location: location,
                          budget: budget,
                          timing: timing,
                          description: description,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class JobDetailsDialog extends StatelessWidget {
  final String title;
  final String jobRef;
  final String postedDate;
  final String location;
  final String budget;
  final String timing;
  final String description;

  const JobDetailsDialog({
    Key? key,
    required this.title,
    required this.jobRef,
    required this.postedDate,
    required this.location,
    required this.budget,
    required this.timing,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Job Ref:', jobRef),
            _buildDetailRow('Posted:', postedDate),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            _buildDetailRow('Location:', location),
            _buildDetailRow('Budget:', budget),
            _buildDetailRow('Timing:', timing),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 5), // SizedBox to control the vertical spacing
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_none, color: Color(0xFF004D40)),
                      Positioned(
                        top: 0,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Color(0xFF004D40),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: const Center(
                            child: Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 1),
                  const Text(
                    '0 Artisans Want to Quote',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF004D40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(225, 37),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                backgroundColor: Colors.white,
                shadowColor: Colors.black,
              ),
              child: const Center(
                child: Text(
                  'VIEW INTERESTED ARTISANS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

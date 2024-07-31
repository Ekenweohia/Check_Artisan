import 'package:check_artisan/jobs/create_job.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            const Center(
              child: Column(
                children: [
                  Text(
                    'How CheckArtisan Works',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    thickness: 5,
                    color: Colors.black,
                    indent: 50,
                    endIndent: 50,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _HowItWorksStep(
              title: 'Post your job',
              description:
                  'There are two ways to go about getting your job done. You can run a simple search to locate a tradesperson of your choice, or you can tell us about the job you need done, where you are and when you want to start.',
            ),
            const SizedBox(height: 14),
            const _HowItWorksStep(
              title: 'Get Quotes',
              description:
                  'We\'ll contact artisans in your area and find you up to 3 that meet your needs. Then we\'ll introduce them to you to arrange a quote.',
            ),
            const SizedBox(height: 14),
            const _HowItWorksStep(
              title: 'Check Ratings',
              description:
                  'Each time we connect you with an artisans we\'ll share ratings left by client that have worked with the artisan. You\'ll be able to read the comments and ratings to help you pick the best.',
            ),
            const SizedBox(height: 14),
            const _HowItWorksStep(
              title: 'Hire the Best',
              description:
                  'Once you\'ve checked out all the ratings, choose the artisan that\'s right for you.',
            ),
            const SizedBox(height: 14),
            const _HowItWorksStep(
              title: 'Job done',
              description:
                  'After the work is complete, return to the site and rate the artisan based on quality of their work, reliability and value for money.',
            ),
            const SizedBox(height: 25),
            Center(
              child: SizedBox(
                width: isSmallScreen ? double.infinity : 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateJobScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'CREATE A NEW JOB',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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

class _HowItWorksStep extends StatelessWidget {
  final String title;
  final String description;

  const _HowItWorksStep({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

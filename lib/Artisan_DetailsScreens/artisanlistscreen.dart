import 'package:check_artisan/Artisan_DetailsScreens/artisan_profile.dart';
import 'package:check_artisan/jobs/quote_request_screen.dart';
import 'package:flutter/material.dart';

class ArtisanListScreen extends StatelessWidget {
  final String title;
  final String artisanType;

  const ArtisanListScreen({
    Key? key,
    required this.title,
    required this.artisanType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: screenSize.width * 0.04),
            child: ArtisanCard(
              name: 'Cheemdee',
              role: '$artisanType in Umuahia',
              registrationDate: 'Registered Member since 2024-04-10',
            ),
          );
        },
      ),
    );
  }
}

class ArtisanCard extends StatelessWidget {
  final String name;
  final String role;
  final String registrationDate;

  const ArtisanCard({
    Key? key,
    required this.name,
    required this.role,
    required this.registrationDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: screenSize.width * 0.08,
                  backgroundImage: const AssetImage('assets/profile.jpg'),
                ),
                SizedBox(width: screenSize.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        registrationDate,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuoteRequestsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF004D40),
                    side: const BorderSide(color: Color(0xFF004D40)),
                  ),
                  child: Text(
                    'GET QUOTE',
                    style: TextStyle(fontSize: screenSize.width * 0.035),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ArtisanProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'VIEW PROFILE',
                    style: TextStyle(fontSize: screenSize.width * 0.035),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

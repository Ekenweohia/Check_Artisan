import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';

class ReviewScreenClient extends StatefulWidget {
  const ReviewScreenClient({Key? key}) : super(key: key);

  @override
  ReviewScreenClientState createState() => ReviewScreenClientState();
}

class ReviewScreenClientState extends State<ReviewScreenClient> {
  bool? _voteOfConfidence;
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArtisanScreen()),
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 30.0), // Adjust the padding as needed
          child: const Text('Review'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            const Text(
              'How would you rate this tradeperson?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 5,
              color: Colors.black,
              indent: 50,
              endIndent: 50,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'If you enjoyed the services of this Artisan, please take a few seconds to rate your experience with the Artisan. It really helps!',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedStars ? Icons.star : Icons.star_border,
                    color: index < _selectedStars ? Colors.yellow : Colors.teal,
                    size: 32.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                );
              }),
            ),
            Divider(
              thickness: 5,
              color: Colors.black,
              indent: 50,
              endIndent: 50,
            ),
            const Divider(height: 32.0),
            SizedBox(
              width: 10,
            ),
            const Text(
              'Vote of Confidence',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Would you love to use this artisan again?',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Yes'),
                    value: true,
                    groupValue: _voteOfConfidence,
                    onChanged: (value) {
                      setState(() {
                        _voteOfConfidence = value;
                      });
                    },
                    activeColor: const Color(0xFF2C6B58),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('No'),
                    value: false,
                    groupValue: _voteOfConfidence,
                    onChanged: (value) {
                      setState(() {
                        _voteOfConfidence = value;
                      });
                    },
                    activeColor: const Color(0xFF2C6B58),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'My Comments and Feedbacks',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                  hintText: 'Enter your comments here',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      CheckartisanNavigator.pushReplacement(
                          context, const HomeClient());
                    },
                    child: const Text(
                      'Post Your Rating',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

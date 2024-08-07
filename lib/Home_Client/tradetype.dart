import 'package:check_artisan/Artisan_DetailsScreens/artisanlistscreen.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class TradeTypeScreen extends StatelessWidget {
  final List<String> trades = [
    'AC & Refrigerator Repairer',
    'Aluminium Maker',
    'Auto Mechanic',
    'Builder',
    'Carpenter',
    'Computer Repairer',
    'Drainage Specialist',
    'Draughtsman',
    'Driver',
    'Electrician',
    'Event Planner & Caterers',
    'Fashion Designer',
    'Gardener',
    'Gas Cooker Repairer',
    'Generator Repairer',
    'Hair Stylist',
    'Home Maintenance/ Repair',
  ];

  TradeTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Trade Type'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for Artisans',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trades.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    onPressed: () {
                      CheckartisanNavigator.push(
                        context,
                        ArtisanListScreen(
                          title: trades[index],
                          artisanType: trades[index],
                        ),
                      );
                    },
                    child: Text(trades[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/complete_profile_artisan2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  CompleteProfileState createState() => CompleteProfileState();
}

class CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedTradeType;
  final List<String> _selectedSkills = [];
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedDistance;

  final bool useApi = false;

  List<String> _tradeTypes = [];
  List<String> _skills = [];
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _cities = [];
  List<String> _distances = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (useApi) {
      try {
        final response = await http.get(Uri.parse(''));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _tradeTypes = List<String>.from(data['tradeTypes']);
            _skills = List<String>.from(data['skills']);
            _countries = List<String>.from(data['countries']);
            _states = List<String>.from(data['states']);
            _cities = List<String>.from(data['cities']);
            _distances = List<String>.from(data['distances']);
          });
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        _loadPlaceholderData();
      }
    } else {
      _loadPlaceholderData();
    }
  }

  void _loadPlaceholderData() {
    setState(() {
      _tradeTypes = [
        'Carpenter',
        'Electrician',
        'Plumber',
        'Painter',
        'Others'
      ];
      _skills = [
        'Wedding Event Planning',
        'Catering Services',
        'Decoration',
        'Others'
      ];
      _countries = ['Country 1', 'Country 2', 'Country 3'];
      _states = ['State 1', 'State 2', 'State 3'];
      _cities = ['City 1', 'City 2', 'City 3'];
      _distances = ['5 km', '10 km', '15 km'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'Business name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'Artisan trade type',
                ),
                value: _selectedTradeType,
                items: _tradeTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTradeType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Artisan skill',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              ..._skills.map((skill) => CheckboxListTile(
                    title: Text(skill),
                    value: _selectedSkills.contains(skill),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  )),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'Country',
                ),
                value: _selectedCountry,
                items: _countries
                    .map((country) => DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'State',
                ),
                value: _selectedState,
                items: _states
                    .map((state) => DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'City',
                ),
                value: _selectedCity,
                items: _cities
                    .map((city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: 'What distance are you willing to travel?',
                ),
                value: _selectedDistance,
                items: _distances
                    .map((distance) => DropdownMenuItem<String>(
                          value: distance,
                          child: Text(distance),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDistance = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    CheckartisanNavigator.push(
                        context, const CompleteProfile2());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

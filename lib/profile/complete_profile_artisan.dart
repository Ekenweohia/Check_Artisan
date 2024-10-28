import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/complete_profile_artisan2.dart'; // Assuming this is the next page
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String labelText,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Circular border for TextFields
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: GoogleFonts.montserrat(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDropdownUnderline({
    required String labelText,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey, width: 1.0), // Underline style
        ),
      ),
    );
  }

  Widget _buildDropdownBox({
    required String labelText,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Circular border for dropdown box
        ),
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void _onContinuePressed() {
    CheckartisanNavigator.push(context, const CompleteProfile2());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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

              // Business Name Field with Title above
              _buildLabeledTextField(
                controller: _businessNameController,
                labelText: 'Enter business name',
                title: 'Business name',
              ),
              const SizedBox(height: 16),

              // Location Field with Title above
              _buildLabeledTextField(
                controller: _locationController,
                labelText: 'Enter location',
                title: 'Location',
              ),
              const SizedBox(height: 16),

              // Artisan Trade Type Dropdown with Underline
              Text(
                'Artisan trade type',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildDropdownUnderline(
                labelText: 'Select artisan trade type',
                items: _tradeTypes,
                selectedValue: _selectedTradeType,
                onChanged: (value) {
                  setState(() {
                    _selectedTradeType = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Artisan Skills with Checkboxes
              Text(
                'Artisan skill',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
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
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              const SizedBox(height: 16),

              // Country Dropdown with Underline
              Text(
                'Country',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildDropdownUnderline(
                labelText: 'Country',
                items: _countries,
                selectedValue: _selectedCountry,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // State Dropdown with Underline
              Text(
                'State',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildDropdownUnderline(
                labelText: 'State',
                items: _states,
                selectedValue: _selectedState,
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // City Dropdown with Underline
              Text(
                'Cities',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildDropdownUnderline(
                labelText: 'Cities',
                items: _cities,
                selectedValue: _selectedCity,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Distance Dropdown with Circular Box
              Text(
                'What distance are you willing to travel?',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              _buildDropdownBox(
                labelText: 'Select distance',
                items: _distances,
                selectedValue: _selectedDistance,
                onChanged: (value) {
                  setState(() {
                    _selectedDistance = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Continue Button with Navigation
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 130,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Small border radius for the button
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

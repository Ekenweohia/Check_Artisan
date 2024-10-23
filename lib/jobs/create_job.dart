import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({Key? key}) : super(key: key);

  @override
  CreateJobScreenState createState() => CreateJobScreenState();
}

class CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedTiming;
  String? _selectedBudget;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  @override
  void dispose() {
    _jobTitleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _postJob() {
    AnimatedSnackBar.rectangle('Success', 'Job Posted Successfully',
            type: AnimatedSnackBarType.success)
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Job'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Give your job a title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  hintText: 'Job Title',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Describe what needs to be done',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText:
                      'Please tell us more about what you want the tradesman to do',
                  border: UnderlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Text(
                'Timing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'When would you like the job to start',
                  border: UnderlineInputBorder(),
                ),
                value: _selectedTiming,
                items: ['Immediately', 'Within a week', 'Within a month']
                    .map((timing) => DropdownMenuItem<String>(
                          value: timing,
                          child: Text(timing),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTiming = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Budget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'What budget do you have in mind',
                  border: UnderlineInputBorder(),
                ),
                value: _selectedBudget,
                items: ['\$100 - \$500', '\$500 - \$1000', '\$1000+']
                    .map((budget) => DropdownMenuItem<String>(
                          value: budget,
                          child: Text(budget),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBudget = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Country',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Country',
                  border: UnderlineInputBorder(),
                ),
                value: _selectedCountry,
                items: ['Country 1', 'Country 2', 'Country 3']
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
              const Text(
                'State',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'State',
                  border: UnderlineInputBorder(),
                ),
                value: _selectedState,
                items: ['State 1', 'State 2', 'State 3']
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
              const Text(
                'Cities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Cities',
                  border: UnderlineInputBorder(),
                ),
                value: _selectedCity,
                items: ['City 1', 'City 2', 'City 3']
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
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: _postJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'POST JOB',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

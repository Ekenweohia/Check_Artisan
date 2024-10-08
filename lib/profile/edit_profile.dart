import 'package:flutter/material.dart';
import 'package:check_artisan/profile/notification.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Chimdimma');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Nwobu');
  final TextEditingController _emailController =
      TextEditingController(text: 'chimdimma.nwobu@ecr-ts.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '********');
  final TextEditingController _addressController = TextEditingController(
      text: '74A Road 5, Federal Low-cost Housing Estate Umuahia');
  final TextEditingController _descriptionController = TextEditingController();

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtisanScreen(),
                    ));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_image.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.edit, color: Color(0xFF004D40)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _firstNameController, label: 'First Name'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _lastNameController, label: 'Last Name'),
                  const SizedBox(height: 20),
                  CustomTextField(controller: _emailController, label: 'Email'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _addressController, label: 'Address'),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    label: 'Country',
                    items: ['Nigeria', 'Ghana', 'Kenya'],
                    selectedItem: selectedCountry,
                    onChanged: (value) =>
                        setState(() => selectedCountry = value),
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    label: 'State',
                    items: ['Abia', 'Lagos', 'Kano'],
                    selectedItem: selectedState,
                    onChanged: (value) => setState(() => selectedState = value),
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    label: 'City',
                    items: ['Umuahia', 'Ikeja', 'Kaduna'],
                    selectedItem: selectedCity,
                    onChanged: (value) => setState(() => selectedCity = value),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      isMultiline: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        debugPrint('First Name: ${_firstNameController.text}');
                        debugPrint('Last Name: ${_lastNameController.text}');
                        debugPrint('Email: ${_emailController.text}');
                        debugPrint('Password: ${_passwordController.text}');
                        debugPrint('Address: ${_addressController.text}');
                        debugPrint('Country: $selectedCountry');
                        debugPrint('State: $selectedState');
                        debugPrint('City: $selectedCity');
                        debugPrint(
                            'Description: ${_descriptionController.text}');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'EDIT PROFILE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Text Field widget with multiline support
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool isMultiline;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.isMultiline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Subtle shadow effect
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            maxLines: isMultiline ? 4 : 1, // Adjust for multiline input
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '$label:', // Use label with colon as hint text
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold, // Bold hint text
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Dropdown Field widget
class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '$label:', // Hint text with colon
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold, // Bold label text
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            border: const UnderlineInputBorder(), // Only underline, no box
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.6)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
          isExpanded: true,
          value: selectedItem,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

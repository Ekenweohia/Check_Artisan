import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 40.0), // Adjusted padding for better alignment
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            _buildPasswordTextField(
              controller: _oldPasswordController,
              labelText: 'Old Password',
              obscureText: _obscureOldPassword,
              toggleObscureText: () {
                setState(() {
                  _obscureOldPassword = !_obscureOldPassword;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordTextField(
              controller: _newPasswordController,
              labelText: 'New Password',
              obscureText: _obscureNewPassword,
              toggleObscureText: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildChip('1 Lowercase'),
                _buildChip('1 Uppercase'),
                _buildChip('1 Digit'),
                _buildChip('8 Characters'),
                _buildChip('1 Special Character'),
              ],
            ),
            const SizedBox(height: 16),
            _buildPasswordTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              toggleObscureText: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 200, // Set a fixed width for the SAVE button
                child: ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'SAVE',
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

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleObscureText,
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(20.0), // Adjust the border radius as needed
      child: Chip(
        label: Text(label, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(
            horizontal: 0, vertical: 0), // Adjust padding inside the chip
      ),
    );
  }

  Future<void> _changePassword() async {
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New password and confirm password do not match')),
      );
      return;
    }

    // Assuming your API endpoint for changing the password is below
    const String apiUrl = 'https://example.com/api/change-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

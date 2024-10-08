import 'package:check_artisan/RegistrationArtisan/login_artisan.dart';
import 'package:check_artisan/VerificationArtisan/otp_verificationartisan.dart';

import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class SubmitRegistration extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;

  const SubmitRegistration({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phoneNumber, password];
}

class GoogleLogin extends RegistrationEvent {}

class FacebookLogin extends RegistrationEvent {}

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;

  const RegistrationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final bool useApi;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RegistrationBloc({this.useApi = false}) : super(RegistrationInitial()) {
    on<SubmitRegistration>(_onSubmitRegistration);
    on<GoogleLogin>(_onGoogleLogin);
    on<FacebookLogin>(_onFacebookLogin);
  }

  Future<void> _onSubmitRegistration(
      SubmitRegistration event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API URL for registration
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': event.firstName,
            'lastName': event.lastName,
            'phoneNumber': event.phoneNumber,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          emit(RegistrationSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(RegistrationFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(RegistrationSuccess());
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLogin(
      GoogleLogin event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Google sign-in failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onFacebookLogin(
      FacebookLogin event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Facebook sign-in failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}

class PhoneArtisan extends StatefulWidget {
  const PhoneArtisan({Key? key}) : super(key: key);

  @override
  PhoneArtisanState createState() => PhoneArtisanState();
}

class PhoneArtisanState extends State<PhoneArtisan> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/reg screen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xF2004D40),
          ),
          Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: SingleChildScrollView(
                    child: BlocProvider(
                      create: (context) => RegistrationBloc(useApi: false),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Got a Phone Number? Let’s Get Started',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSmallTextField(
                            controller: _firstNameController,
                            labelText: 'First Name',
                          ),
                          const SizedBox(height: 20),
                          _buildSmallTextField(
                            controller: _lastNameController,
                            labelText: 'Last Name',
                          ),
                          const SizedBox(height: 20),
                          _buildSmallTextField(
                            controller: _phoneController,
                            labelText: 'Phone Number',
                          ),
                          const SizedBox(height: 20),
                          _buildPasswordTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: _obscurePassword,
                            toggleObscureText: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildPasswordTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirm Password',
                            obscureText: _obscureConfirmPassword,
                            toggleObscureText: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'CLICK HERE TO READ TERMS AND CONDITIONS',
                            style: TextStyle(
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Switch(
                                value: _isSwitched,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isSwitched = value;
                                  });
                                },
                                activeColor: const Color(0xFF004D40),
                              ),
                              const Text('I agree to the terms and conditions'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<RegistrationBloc, RegistrationState>(
                            listener: (context, state) {
                              if (state is RegistrationSuccess) {
                                CheckartisanNavigator.push(
                                    context,
                                    OTPVerificationArtisanScreen(
                                        phoneNumber: _phoneController.text));
                              } else if (state is RegistrationFailure) {
                                AnimatedSnackBar.rectangle('Error',
                                        'Please Check Internet Connection',
                                        type: AnimatedSnackBarType.error)
                                    .show(context);
                              }
                            },
                            builder: (context, state) {
                              if (state is RegistrationLoading) {
                                return const CircularLoadingWidget();
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final firstName = _firstNameController.text;
                                    final lastName = _lastNameController.text;
                                    final phoneNumber = _phoneController.text;
                                    final password = _passwordController.text;
                                    final confirmPassword =
                                        _confirmPasswordController.text;

                                    if (password != confirmPassword) {
                                      AnimatedSnackBar.rectangle(
                                        "Warning",
                                        "Passwords do not match",
                                        type: AnimatedSnackBarType.warning,
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.bottom,
                                      ).show(context);
                                      return;
                                    }

                                    context.read<RegistrationBloc>().add(
                                          SubmitRegistration(
                                            firstName: firstName,
                                            lastName: lastName,
                                            phoneNumber: phoneNumber,
                                            password: password,
                                          ),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF004D40),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  child: const Text('SIGN UP'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialLoginButton(
                                onPressed: () {
                                  context
                                      .read<RegistrationBloc>()
                                      .add(GoogleLogin());
                                },
                                label: 'Google account',
                                assetPath: 'assets/icons/google.png',
                              ),
                              const SizedBox(width: 15),
                              _buildSocialLoginButton(
                                onPressed: () {
                                  context
                                      .read<RegistrationBloc>()
                                      .add(FacebookLogin());
                                },
                                label: 'Facebook account',
                                assetPath: 'assets/icons/facebook.png',
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              CheckartisanNavigator.push(
                                  context, const LoginArtisan());
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Already Have an account? ',
                                style: TextStyle(
                                  color:
                                      Colors.black, // Black color for this part
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'LOGIN',
                                    style: TextStyle(
                                      color: Color(0xFF004D40),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return SizedBox(
      height: 45, // Uniform height for all TextFields
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true, // Makes the TextField denser
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 12), // Adjust padding
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
        ),
        style: GoogleFonts.montserrat(fontSize: 14), // Apply Montserrat font
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
      height: 45, // Uniform height for all TextFields
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true, // Makes the TextField denser
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 12), // Adjust padding
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleObscureText,
          ),
        ),
        style: GoogleFonts.montserrat(fontSize: 14), // Apply Montserrat font
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required VoidCallback onPressed,
    required String label,
    required String assetPath,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          side: BorderSide(color: Colors.grey),
        ),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Image.asset(
        assetPath,
        height: 30,
        width: 30,
      ),
      label: Text(
        label,
        style: GoogleFonts.montserrat(fontSize: 12), // Apply Montserrat font
      ),
    );
  }
}

import 'package:check_artisan/VerificationClient/otp_verification.dart';
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
import 'package:check_artisan/RegistrationClient/login_client.dart';

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
        await Future.delayed(const Duration(seconds: 3));
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
        emit(const RegistrationFailure('Google sign-in was cancelled.'));
      }
    } catch (e) {
      emit(RegistrationFailure('Google sign-in failed: $e'));
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
        emit(const RegistrationFailure('Facebook sign-in failed.'));
      }
    } catch (e) {
      emit(RegistrationFailure('Facebook sign-in failed: $e'));
    }
  }
}

class PhoneClient extends StatefulWidget {
  const PhoneClient({Key? key}) : super(key: key);

  @override
  PhoneClientState createState() => PhoneClientState();
}

class PhoneClientState extends State<PhoneClient> {
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BlocProvider(
                        create: (context) => RegistrationBloc(useApi: false),
                        child: BlocConsumer<RegistrationBloc, RegistrationState>(
                          listener: (context, state) {
                            if (state is RegistrationSuccess) {
                              CheckartisanNavigator.push(
                                  context,
                                  OTPVerificationScreen(
                                      phoneNumber: _phoneController.text));
                            } else if (state is RegistrationFailure) {
                              AnimatedSnackBar.rectangle(
                                  'Error', state.error,
                                  type: AnimatedSnackBarType.error)
                                  .show(context);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Got a Phone Number? Let’s Get Started',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
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
                                _buildSmallTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  obscureText: _obscurePassword,
                                  onIconPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                const SizedBox(height: 20),
                                _buildSmallTextField(
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  obscureText: _obscureConfirmPassword,
                                  onIconPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                const SizedBox(height: 20),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'CLICK HERE TO READ TERMS AND CONDITIONS',
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Color(0xFF004D40),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                               Row(
  children: [
    Switch(
      value: _isSwitched,
      onChanged: (bool value) {
        setState(() {
          _isSwitched = value;
        });
      },
      activeColor: const Color(0xFF004D40), // Active color (when the switch is on)
      inactiveThumbColor: Colors.grey, // Thumb color when the switch is off
      inactiveTrackColor: Colors.grey.shade300, // Track color when the switch is off
    ),
    const SizedBox(width: 5,),
    const Text('I agree to the terms and conditions', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),),
  ],
),

                                const SizedBox(height: 25),
                                if (state is RegistrationLoading)
                                  const CircularLoadingWidget()
                                else
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final firstName = _firstNameController.text;
                                        final lastName = _lastNameController.text;
                                        final phoneNumber = _phoneController.text;
                                        final password = _passwordController.text;
                                        final confirmPassword = _confirmPasswordController.text;

                                        if (!_validateInputs(context, firstName, lastName, phoneNumber, password, confirmPassword)) {
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
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shadowColor: Colors.black26,
                                        elevation: 8,
                                      ),
                                      child: const Text('SIGN UP'),
                                    ),
                                  ),
                                const SizedBox(height: 60),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialLoginButton(
                                      onPressed: () {
                                        context.read<RegistrationBloc>().add(GoogleLogin());
                                      },
                                      label: 'Google',
                                      assetPath: 'assets/icons/google.png',
                                    ),
                                    const SizedBox(width: 16),
                                    _buildSocialLoginButton(
                                      onPressed: () {
                                        context.read<RegistrationBloc>().add(FacebookLogin());
                                      },
                                      label: 'Facebook',
                                      assetPath: 'assets/icons/facebook.png',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                TextButton(
                                  onPressed: () {
                                    CheckartisanNavigator.push(context, const LoginClient());
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Already Have an account? ',
                                      style: TextStyle(
                                        color: Colors.black,
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
                                ),
                              ],
                            );
                          },
                        ),
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

  bool _validateInputs(BuildContext context, String firstName, String lastName, String phoneNumber, String password, String confirmPassword) {
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstName)) {
      _showWarning(context, 'Please enter a valid first name');
      return false;
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(lastName)) {
      _showWarning(context, 'Please enter a valid last name');
      return false;
    }

    if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(phoneNumber)) {
      _showWarning(context, 'Please enter a valid phone number');
      return false;
    }

    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      _showWarning(
          context,
          'Password must be at least 8 characters long, '
          'include an uppercase letter, a lowercase letter, a number, '
          'and a special character');
      return false;
    }

    if (password != confirmPassword) {
      _showWarning(context, 'Passwords do not match');
      return false;
    }

    if (!_isSwitched) {
      _showWarning(context, 'You must agree to the terms and conditions');
      return false;
    }

    return true;
  }

  void _showWarning(BuildContext context, String message) {
    AnimatedSnackBar.rectangle('Warning', message, type: AnimatedSnackBarType.warning).show(context);
  }

  Widget _buildSmallTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    VoidCallback? onIconPressed,
    IconData? icon,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: icon != null
              ? IconButton(
                  icon: Icon(icon),
                  onPressed: onIconPressed,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required VoidCallback onPressed,
    required String label,
    required String assetPath,
  }) {
    return SizedBox(
      width: 140,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          height: 24,
          width: 24,
        ),
        label: Text(
          label,
          style: GoogleFonts.montserrat(fontSize: 12),
        ),
      ),
    );
  }
}

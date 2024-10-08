import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/RegistrationArtisan/login_artisan.dart';
import 'package:check_artisan/VerificationArtisan/email_confirmationartisan.dart';

import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, phoneNumber];
}

class LoginSubmitted extends AuthEvent {
  final String emailOrPhone;
  final String password;

  const LoginSubmitted({
    required this.emailOrPhone,
    required this.password,
  });

  @override
  List<Object> get props => [emailOrPhone, password];
}

class GoogleLogin extends AuthEvent {}

class FacebookLogin extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final bool useApi;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc({this.useApi = false}) : super(AuthInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleLogin>(_onGoogleLogin);
    on<FacebookLogin>(_onFacebookLogin);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse('https://checkartisan.com/api/appemailregistration'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': event.email,
            'password': event.password,
            'firstname': event.firstName,
            'lastname': event.lastName,
            'role_id': '2',
            'phone': event.phoneNumber,
          }),
        );

        if (response.statusCode == 200) {
          emit(AuthSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(AuthFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3));
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API URL for login
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'emailOrPhone': event.emailOrPhone,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          emit(AuthSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(AuthFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3));
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLogin(
      GoogleLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Google sign-in was cancelled.'));
      }
    } catch (e) {
      emit(AuthFailure('Google sign-in failed: $e'));
    }
  }

  Future<void> _onFacebookLogin(
      FacebookLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Facebook sign-in failed: ${result.message}'));
      }
    } catch (e) {
      emit(AuthFailure('Facebook sign-in failed: $e'));
    }
  }
}

class EmailArtisan extends StatefulWidget {
  const EmailArtisan({Key? key}) : super(key: key);

  @override
  EmailArtisanState createState() => EmailArtisanState();
}

class EmailArtisanState extends State<EmailArtisan> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
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
                      create: (context) =>
                          AuthBloc(useApi: false), // Set to true to use API
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            CheckartisanNavigator.push(
                                context,
                                EmailConfirmationArtisan(
                                    email: _emailController.text));
                          } else if (state is AuthFailure) {
                            AnimatedSnackBar.rectangle('Error', state.error,
                                    type: AnimatedSnackBarType.error)
                                .show(context);
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Got an Email? Let’s Get Started',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
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
                                controller: _emailController,
                                labelText: 'Email',
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
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              const SizedBox(height: 20),
                              _buildSmallTextField(
                                controller: _phoneNumberController,
                                labelText: 'Phone Number',
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'CLICK HERE TO READ TERMS AND CONDITIONS',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF004D40),
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  const Text(
                                      'I agree to the terms and conditions'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (state is AuthLoading)
                                const CircularLoadingWidget()
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateInputs(context)) {
                                        final firstName =
                                            _firstNameController.text;
                                        final lastName =
                                            _lastNameController.text;
                                        final email = _emailController.text;
                                        final password =
                                            _passwordController.text;
                                        final phoneNumber =
                                            _phoneNumberController.text;

                                        context.read<AuthBloc>().add(
                                              RegisterSubmitted(
                                                firstName: firstName,
                                                lastName: lastName,
                                                email: email,
                                                password: password,
                                                phoneNumber: phoneNumber,
                                              ),
                                            );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF004D40),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
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
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(GoogleLogin());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/icons/google.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    label: const Text('Google account'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(FacebookLogin());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/icons/facebook.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    label: const Text('Facebook account'),
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
            ],
          ),
        ],
      ),
    );
  }

  bool _validateInputs(BuildContext context) {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final phoneNumber = _phoneNumberController.text;

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstName)) {
      _showWarning(context, 'Please enter a valid first name');
      return false;
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(lastName)) {
      _showWarning(context, 'Please enter a valid last name');
      return false;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
      _showWarning(context, 'Please enter a valid @gmail.com email address');
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

    if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(phoneNumber)) {
      _showWarning(context, 'Please enter a valid phone number');
      return false;
    }

    if (!_isSwitched) {
      _showWarning(context, 'You must agree to the terms and conditions');
      return false;
    }

    return true;
  }

  void _showWarning(BuildContext context, String message) {
    AnimatedSnackBar.rectangle('Warning', message,
            type: AnimatedSnackBarType.warning)
        .show(context);
  }

  Widget _buildSmallTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    VoidCallback? onIconPressed,
    IconData? icon,
  }) {
    return SizedBox(
      height: 40, // Adjust the height of the TextField
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true, // Reduces the internal height
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
}

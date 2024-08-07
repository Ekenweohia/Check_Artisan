import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/RegistrationClient/login_client.dart';
import 'package:check_artisan/VerificationClient/email_confirmation.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
          Uri.parse(''), // API URL for registration
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': event.firstName,
            'lastName': event.lastName,
            'email': event.email,
            'password': event.password,
            'phoneNumber': event.phoneNumber,
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

class EmailClient extends StatefulWidget {
  const EmailClient({Key? key}) : super(key: key);

  @override
  EmailClientState createState() => EmailClientState();
}

class EmailClientState extends State<EmailClient> {
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
                      create: (context) => AuthBloc(
                          useApi: true), // Set to true when API is ready
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            CheckartisanNavigator.push(
                                context,
                                EmailConfirmation(
                                    email: _emailController.text));
                          } else if (state is AuthFailure) {
                            AnimatedSnackBar.rectangle(
                                    'Error', 'Authentication Error',
                                    type: AnimatedSnackBarType.error)
                                .show(context);
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Got an Email? Let’s Get Started',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _firstNameController,
                                labelText: 'First Name',
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _emailController,
                                labelText: 'Email',
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _phoneNumberController,
                                labelText: 'Phone Number',
                              ),
                              const SizedBox(height: 16),
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
                                      final firstName =
                                          _firstNameController.text;
                                      final lastName = _lastNameController.text;
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      final confirmPassword =
                                          _confirmPasswordController.text;
                                      final phoneNumber =
                                          _phoneNumberController.text;

                                      if (password != confirmPassword) {
                                        AnimatedSnackBar.rectangle('Warning',
                                                'Passwords Do Not Match',
                                                type: AnimatedSnackBarType
                                                    .warning)
                                            .show(context);

                                        return;
                                      }

                                      context.read<AuthBloc>().add(
                                            RegisterSubmitted(
                                              firstName: firstName,
                                              lastName: lastName,
                                              email: email,
                                              password: password,
                                              phoneNumber: phoneNumber,
                                            ),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF004D40),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialLoginButton(
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(GoogleLogin());
                                    },
                                    label: 'Google account',
                                    assetPath: 'assets/icons/google.png',
                                  ),
                                  const SizedBox(width: 16),
                                  _buildSocialLoginButton(
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
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
                                      context, const LoginClient());
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required VoidCallback onPressed,
    required String label,
    required String assetPath,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
          shadowColor: Colors.grey.withOpacity(0.5),
          elevation: 8,
        ),
        icon: Image.asset(
          assetPath,
          height: 30,
          width: 30,
        ),
        label: Text(label),
      ),
    );
  }
}

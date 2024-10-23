import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/RegistrationClient/register_client.dart';
import 'package:check_artisan/VerificationClient/password_reset.dart';
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
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleLogin>(_onGoogleLogin);
    on<FacebookLogin>(_onFacebookLogin);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // Add your login API URL here
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
        await Future.delayed(const Duration(seconds: 1));
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

class LoginClient extends StatefulWidget {
  const LoginClient({Key? key}) : super(key: key);

  @override
  LoginClientState createState() => LoginClientState();
}

class LoginClientState extends State<LoginClient> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  bool _obscurePassword = true;

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
              const SizedBox(height: 200),
              Center(
                child: Image.asset(
                  'assets/icons/logo checkartisan 1.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 50),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BlocProvider(
                        create: (context) => AuthBloc(useApi: false),
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              CheckartisanNavigator.push(
                                  context, const HomeClient());
                            } else if (state is AuthFailure) {
                              AnimatedSnackBar.rectangle(
                                      'Error', 'Check Internet Connection',
                                      type: AnimatedSnackBarType.error)
                                  .show(context);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSmallTextField(
                                  controller: _emailOrPhoneController,
                                  labelText: 'Email/Phone Number',
                                ),
                                const SizedBox(height: 16),
                                _buildPasswordTextField(
                                  controller: _loginPasswordController,
                                  labelText: 'Password',
                                  obscureText: _obscurePassword,
                                  toggleObscureText: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                const SizedBox(height: 30),
                                if (state is AuthLoading)
                                  const CircularProgressIndicator()
                                else
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final emailOrPhone =
                                            _emailOrPhoneController.text;
                                        final password =
                                            _loginPasswordController.text;

                                        context.read<AuthBloc>().add(
                                              LoginSubmitted(
                                                emailOrPhone: emailOrPhone,
                                                password: password,
                                              ),
                                            );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF004D40),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shadowColor: Colors.black26,
                                        elevation: 8,
                                      ),
                                      child: const Text('LOGIN'),
                                    ),
                                  ),
                                const SizedBox(height: 0.1),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      CheckartisanNavigator.push(
                                          context, const PasswordResetScreen());
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          color: Color(0xFF004D40),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 45),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialLoginButton(
                                      onPressed: () {
                                        context
                                            .read<AuthBloc>()
                                            .add(GoogleLogin());
                                      },
                                      label: 'Google',
                                      assetPath: 'assets/icons/google.png',
                                    ),
                                    const SizedBox(width: 16),
                                    _buildSocialLoginButton(
                                      onPressed: () {
                                        context
                                            .read<AuthBloc>()
                                            .add(FacebookLogin());
                                      },
                                      label: 'Facebook',
                                      assetPath: 'assets/icons/facebook.png',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    CheckartisanNavigator.push(
                                        context, const RegisterClient());
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Don’t Have an account? ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'SIGN UP',
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

  Widget _buildSmallTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
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
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

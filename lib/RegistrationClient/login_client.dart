import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/RegistrationClient/register_client.dart';
import 'package:check_artisan/VerificationClient/password_reset.dart';
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
        emit(const AuthFailure('Google sign-in failed'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
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
        emit(const AuthFailure('Facebook sign-in failed'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = MediaQuery.of(context).size.width * 0.05;
          return Stack(
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
                  SizedBox(height: constraints.maxHeight * 0.15),
                  Center(
                    child: Image.asset(
                      'assets/icons/logo checkartisan 1.png',
                      width: constraints.maxWidth * 0.75,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(padding),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24.0)),
                      ),
                      child: SingleChildScrollView(
                        child: BlocProvider(
                          create: (context) => AuthBloc(useApi: false),
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeClient(),
                                  ),
                                );
                              } else if (state is AuthFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${state.error}')),
                                );
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
                                  Container(
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
                                      controller: _emailOrPhoneController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        labelText: 'Email/Phone Number',
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
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
                                      controller: _loginPasswordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        labelText: 'Password',
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PasswordResetScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style:
                                            TextStyle(color: Color(0xFF004D40)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
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
                                              vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                              Radius.circular(0),
                                            ),
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          elevation: 5,
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
                                              Radius.circular(0),
                                            ),
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          elevation: 5,
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
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterClient(),
                                        ),
                                      );
                                    },
                                    child: RichText(
                                      text: const TextSpan(
                                        text: 'Don’t Have an account?',
                                        style: TextStyle(
                                          color: Colors
                                              .black, // Black color for this part
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'SIGN UP',
                                            style: TextStyle(
                                              color: Color(
                                                  0xFF004D40), // Green color for this part
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
          );
        },
      ),
    );
  }
}

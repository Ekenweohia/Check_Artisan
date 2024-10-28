import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

abstract class PasswordResetArtisanEvent extends Equatable {
  const PasswordResetArtisanEvent();

  @override
  List<Object> get props => [];
}

class SendPasswordResetEmail extends PasswordResetArtisanEvent {
  final String emailOrPhone;

  const SendPasswordResetEmail(this.emailOrPhone);

  @override
  List<Object> get props => [emailOrPhone];
}

abstract class PasswordResetArtisanState extends Equatable {
  const PasswordResetArtisanState();

  @override
  List<Object> get props => [];
}

class PasswordResetArtisanInitial extends PasswordResetArtisanState {}

class PasswordResetLoading extends PasswordResetArtisanState {}

class PasswordResetSuccess extends PasswordResetArtisanState {}

class PasswordResetFailure extends PasswordResetArtisanState {
  final String error;

  const PasswordResetFailure(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordResetBloc
    extends Bloc<PasswordResetArtisanEvent, PasswordResetArtisanState> {
  final bool useApi;

  PasswordResetBloc({this.useApi = false})
      : super(PasswordResetArtisanInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(SendPasswordResetEmail event,
      Emitter<PasswordResetArtisanState> emit) async {
    emit(PasswordResetLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(
              'https://checkartisan.com/api/forgot-password'), // API for password reset
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'emailOrPhone': event.emailOrPhone,
          }),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody['data'] == 'Email sent.') {
            emit(PasswordResetSuccess());
          } else {
            emit(PasswordResetFailure('Unexpected response: ${response.body}'));
          }
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
          emit(PasswordResetFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(PasswordResetSuccess());
      }
    } on SocketException {
      emit(const PasswordResetFailure('No internet connection'));
    } catch (e) {
      emit(PasswordResetFailure('Network request failed: ${e.toString()}'));
    }
  }
}

class PasswordResetAppScreen extends StatefulWidget {
  const PasswordResetAppScreen({Key? key}) : super(key: key);

  @override
  PasswordResetAppScreenState createState() => PasswordResetAppScreenState();
}

class PasswordResetAppScreenState extends State<PasswordResetAppScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) =>
            PasswordResetBloc(useApi: false), // change to true when using API
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/password_reset.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter the email/ phone number associated with your account and we\'ll send an email with instructions to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailPhoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Email/Phone Number',
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<PasswordResetBloc, PasswordResetArtisanState>(
                listener: (context, state) {
                  if (state is PasswordResetSuccess) {
                    AnimatedSnackBar.rectangle(
                            'Success', 'Password Reset Instructions Sent',
                            type: AnimatedSnackBarType.success)
                        .show(context);
                  } else if (state is PasswordResetFailure) {
                    AnimatedSnackBar.rectangle('Error',
                            'Sorry An Error Occurred. Check Your Internet Connection',
                            type: AnimatedSnackBarType.error)
                        .show(context);
                  }
                },
                builder: (context, state) {
                  if (state is PasswordResetLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final emailOrPhone = _emailPhoneController.text;
                        if (_validateInput(emailOrPhone)) {
                          context
                              .read<PasswordResetBloc>()
                              .add(SendPasswordResetEmail(emailOrPhone));
                        } else {
                          AnimatedSnackBar.rectangle('Invalid Input',
                                  'Please enter a valid email or phone number',
                                  type: AnimatedSnackBarType.warning)
                              .show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('SEND INSTRUCTIONS'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInput(String input) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return emailRegex.hasMatch(input) || phoneRegex.hasMatch(input);
  }
}

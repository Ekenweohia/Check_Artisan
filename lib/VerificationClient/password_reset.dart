import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class SendPasswordResetEmail extends PasswordResetEvent {
  final String emailOrPhone;

  const SendPasswordResetEmail(this.emailOrPhone);

  @override
  List<Object> get props => [emailOrPhone];
}

abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {}

class PasswordResetFailure extends PasswordResetState {
  final String error;

  const PasswordResetFailure(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final bool useApi;

  PasswordResetBloc({this.useApi = false}) : super(PasswordResetInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(
      SendPasswordResetEmail event, Emitter<PasswordResetState> emit) async {
    emit(PasswordResetLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API for password reset
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'emailOrPhone': event.emailOrPhone,
          }),
        );

        if (response.statusCode == 200) {
          emit(PasswordResetSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(PasswordResetFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(PasswordResetSuccess());
      }
    } catch (e) {
      emit(PasswordResetFailure(e.toString()));
    }
  }
}

class PasswordResetApp extends StatelessWidget {
  const PasswordResetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Reset',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const PasswordResetScreen(),
    );
  }
}

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => PasswordResetBloc(
            useApi: false), // will change to true when Api is ready
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 90),
              BlocConsumer<PasswordResetBloc, PasswordResetState>(
                listener: (context, state) {
                  if (state is PasswordResetSuccess) {
                    AnimatedSnackBar.rectangle(
                      'Success',
                      'Password reset instructions sent!',
                      type: AnimatedSnackBarType.success,
                    ).show(context);
                  } else if (state is PasswordResetFailure) {
                    AnimatedSnackBar.rectangle(
                      'Error',
                      'Error: ${state.error}',
                      type: AnimatedSnackBarType.error,
                    ).show(context);
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
                        context
                            .read<PasswordResetBloc>()
                            .add(SendPasswordResetEmail(emailOrPhone));
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
}

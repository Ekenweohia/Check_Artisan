import 'dart:io';
import 'package:check_artisan/VerificationArtisan/email_confirmationartisan.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

// State
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
          Uri.parse('https://checkartisan.com/api/forgot-password'),
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

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => PasswordResetBloc(useApi: true),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.r, vertical: 30.0.r),
          child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
            listener: (context, state) {
              if (state is PasswordResetSuccess) {
                AnimatedSnackBar.rectangle(
                  'Success',
                  'Password reset instructions sent!',
                  type: AnimatedSnackBarType.success,
                ).show(context);
                CheckartisanNavigator.push(
                    context,
                    EmailConfirmationArtisan(
                        email: _emailPhoneController.text));
              } else if (state is PasswordResetFailure) {
                AnimatedSnackBar.rectangle(
                  'Error',
                  'Error: ${state.error}',
                  type: AnimatedSnackBarType.error,
                ).show(context);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50.h),
                      Image.asset(
                        'assets/icons/password_reset.png',
                        width: 200.w,
                        height: 200.h,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Enter the email/phone number associated with your account and we\'ll send an email with instructions to reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailPhoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          labelText: 'Email/Phone Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone number';
                          }
                          if (!_validateInput(value)) {
                            return 'Please enter a valid email or phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 90),
                      if (state is PasswordResetLoading)
                        const CircularLoadingWidget()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final emailOrPhone = _emailPhoneController.text;
                                context
                                    .read<PasswordResetBloc>()
                                    .add(SendPasswordResetEmail(emailOrPhone));
                              } else {
                                AnimatedSnackBar.rectangle(
                                  'Warning',
                                  'Please correct the errors in the form',
                                  type: AnimatedSnackBarType.warning,
                                ).show(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004D40),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 20.r),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('SEND INSTRUCTIONS'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
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

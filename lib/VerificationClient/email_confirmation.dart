import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class EmailConfirmationEvent extends Equatable {
  const EmailConfirmationEvent();

  @override
  List<Object> get props => [];
}

class SendEmailConfirmation extends EmailConfirmationEvent {
  final String email;

  const SendEmailConfirmation(this.email);

  @override
  List<Object> get props => [email];
}

class ResendEmailConfirmation extends EmailConfirmationEvent {
  final String email;

  const ResendEmailConfirmation(this.email);

  @override
  List<Object> get props => [email];
}

abstract class EmailConfirmationState extends Equatable {
  const EmailConfirmationState();

  @override
  List<Object> get props => [];
}

class EmailConfirmationInitial extends EmailConfirmationState {}

class EmailConfirmationLoading extends EmailConfirmationState {}

class EmailConfirmationSuccess extends EmailConfirmationState {}

class EmailConfirmationFailure extends EmailConfirmationState {
  final String error;

  const EmailConfirmationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class EmailConfirmationBloc
    extends Bloc<EmailConfirmationEvent, EmailConfirmationState> {
  final bool useApi;

  EmailConfirmationBloc({this.useApi = false})
      : super(EmailConfirmationInitial()) {
    on<SendEmailConfirmation>(_onSendEmailConfirmation);
    on<ResendEmailConfirmation>(_onResendEmailConfirmation);
  }

  Future<void> _onSendEmailConfirmation(
      SendEmailConfirmation event, Emitter<EmailConfirmationState> emit) async {
    emit(EmailConfirmationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API URL for sending email confirmation
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': event.email,
          }),
        );

        if (response.statusCode == 200) {
          emit(EmailConfirmationSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(EmailConfirmationFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(EmailConfirmationSuccess());
      }
    } catch (e) {
      emit(EmailConfirmationFailure(e.toString()));
    }
  }

  Future<void> _onResendEmailConfirmation(ResendEmailConfirmation event,
      Emitter<EmailConfirmationState> emit) async {
    emit(EmailConfirmationLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(''), // API URL for resending email confirmation
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': event.email,
          }),
        );

        if (response.statusCode == 200) {
          emit(EmailConfirmationSuccess());
        } else {
          final error = jsonDecode(response.body)['error'];
          emit(EmailConfirmationFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(EmailConfirmationSuccess());
      }
    } catch (e) {
      emit(EmailConfirmationFailure(e.toString()));
    }
  }
}

class EmailConfirmation extends StatelessWidget {
  final String email;

  const EmailConfirmation({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => EmailConfirmationBloc(
            useApi: false), // will Change to true when API is ready
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/confirmation.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 150),
                const Text(
                  'Confirm your email address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We sent a confirmation mail to:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF004D40),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Check your email and click on the confirmation link to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<EmailConfirmationBloc, EmailConfirmationState>(
                  listener: (context, state) {
                    if (state is EmailConfirmationSuccess) {
                      AnimatedSnackBar.rectangle(
                          'Success', 'Confirmation Email Sent',
                          type: AnimatedSnackBarType.success);
                    } else if (state is EmailConfirmationFailure) {
                      AnimatedSnackBar.rectangle('Error',
                          'An Error Occured Check Your Internet Connection',
                          type: AnimatedSnackBarType.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is EmailConfirmationLoading) {
                      return const CircularLoadingWidget();
                    }
                    return TextButton(
                      onPressed: () {
                        context
                            .read<EmailConfirmationBloc>()
                            .add(ResendEmailConfirmation(email));
                      },
                      child: const Text(
                        'Resend Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF004D40),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

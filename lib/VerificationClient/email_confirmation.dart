import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

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

class EmailConfirmationBloc extends Bloc<EmailConfirmationEvent, EmailConfirmationState> {
  final bool useApi;

  EmailConfirmationBloc({this.useApi = false}) : super(EmailConfirmationInitial()) {
    on<SendEmailConfirmation>(_onSendEmailConfirmation);
    on<ResendEmailConfirmation>(_onResendEmailConfirmation);
  }

  Future<void> _onSendEmailConfirmation(
      SendEmailConfirmation event, Emitter<EmailConfirmationState> emit) async {
    emit(EmailConfirmationLoading());

    try {
      if (useApi) {
        final response = await _sendRequest(event.email);

        if (response.statusCode == 200) {
          emit(EmailConfirmationSuccess());
        } else {
          emit(EmailConfirmationFailure(
              _getErrorMessage(response.statusCode, response.reasonPhrase)));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3));
        emit(EmailConfirmationSuccess());
      }
    } catch (_) {
      emit(const EmailConfirmationFailure('Check your internet connection'));
    }
  }

  Future<void> _onResendEmailConfirmation(
      ResendEmailConfirmation event, Emitter<EmailConfirmationState> emit) async {
    emit(EmailConfirmationLoading());

    try {
      if (useApi) {
        final response = await _sendRequest(event.email);

        if (response.statusCode == 200) {
          emit(EmailConfirmationSuccess());
        } else {
          emit(EmailConfirmationFailure(
              _getErrorMessage(response.statusCode, response.reasonPhrase)));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(EmailConfirmationSuccess());
      }
    } catch (_) {
      emit(const EmailConfirmationFailure('Check your internet connection'));
    }
  }

  Future<http.Response> _sendRequest(String email) {
    return http.get(Uri.parse('https://checkartisan.com/api/startup/$email'));
  }

  String _getErrorMessage(int statusCode, String? reasonPhrase) {
    switch (statusCode) {
      case 500:
        return reasonPhrase ?? 'Internal Server Error';
      case 404:
        return reasonPhrase ?? 'Not Found';
      case 401:
        return reasonPhrase ?? 'Unauthorized';
      default:
        return reasonPhrase ?? 'Unknown error';
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
        create: (context) => EmailConfirmationBloc(useApi: true)
          ..add(SendEmailConfirmation(email)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/icons/confirmation.png'),
                  width: 300,
                  height: 300,
                ),
                // Reduced spacing between the image and the text to bring them closer together
                const SizedBox(height: 8), // Smaller spacing for tighter layout
                const Text(
                  'Confirm your email address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4), // Reduced spacing to keep the text close
                const Text(
                  'We sent a confirmation mail to:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2), // Minimal spacing for better compactness
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF004D40),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2), // Minimal spacing to keep it visually connected
                const Text(
                  'Check your email and click on the confirmation link to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16), // Slightly reduced spacing before the button
                BlocConsumer<EmailConfirmationBloc, EmailConfirmationState>(
                  listener: (context, state) {
                    if (state is EmailConfirmationSuccess) {
                      AnimatedSnackBar.rectangle(
                        'Success',
                        'Confirmation Email Sent',
                        type: AnimatedSnackBarType.success,
                      ).show(context);
                    } else if (state is EmailConfirmationFailure) {
                      AnimatedSnackBar.rectangle(
                        'Error',
                        'An Error Occurred: ${state.error}',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is EmailConfirmationLoading) {
                      return const CircularLoadingWidget();
                    }
                    return SizedBox(
                      width: double.infinity, // Full-width button
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0), // Button padding
                        child: TextButton(
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

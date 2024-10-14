import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/VerificationArtisan/otp_verificationartisan.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class PhoneNumberEvent extends Equatable {
  const PhoneNumberEvent();

  @override
  List<Object> get props => [];
}

class ChangePhoneNumber extends PhoneNumberEvent {
  final String oldPhoneNumber;
  final String newPhoneNumber;

  const ChangePhoneNumber({
    required this.oldPhoneNumber,
    required this.newPhoneNumber,
  });

  @override
  List<Object> get props => [oldPhoneNumber, newPhoneNumber];
}

abstract class PhoneNumberState extends Equatable {
  const PhoneNumberState();

  @override
  List<Object> get props => [];
}

class PhoneNumberInitial extends PhoneNumberState {}

class PhoneNumberLoading extends PhoneNumberState {}

class PhoneNumberChanged extends PhoneNumberState {}

class PhoneNumberError extends PhoneNumberState {
  final String error;

  const PhoneNumberError(this.error);

  @override
  List<Object> get props => [error];
}

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  final bool useApi;

  PhoneNumberBloc({this.useApi = false}) : super(PhoneNumberInitial()) {
    on<ChangePhoneNumber>(_onChangePhoneNumber);
  }

  Future<void> _onChangePhoneNumber(
      ChangePhoneNumber event, Emitter<PhoneNumberState> emit) async {
    emit(PhoneNumberLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse('https://yourapiendpoint.com/change_phone'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'oldPhoneNumber': event.oldPhoneNumber,
            'newPhoneNumber': event.newPhoneNumber,
          }),
        );

        if (response.statusCode == 200) {
          emit(PhoneNumberChanged());
        } else {
          emit(const PhoneNumberError('Failed to change phone number'));
        }
      } else {
        // Simulate successful phone number change
        await Future.delayed(const Duration(seconds: 1));
        emit(PhoneNumberChanged());
      }
    } catch (e) {
      emit(PhoneNumberError(e.toString()));
    }
  }
}

class ChangePhoneNumberScreen extends StatefulWidget {
  const ChangePhoneNumberScreen({Key? key}) : super(key: key);

  @override
  ChangePhoneNumberScreenState createState() => ChangePhoneNumberScreenState();
}

class ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  final TextEditingController _oldPhoneNumberController =
      TextEditingController();
  final TextEditingController _newPhoneNumberController =
      TextEditingController();

  @override
  void dispose() {
    _oldPhoneNumberController.dispose();
    _newPhoneNumberController.dispose();
    super.dispose();
  }

  void _changePhoneNumber() {
    context.read<PhoneNumberBloc>().add(
          ChangePhoneNumber(
            oldPhoneNumber: _oldPhoneNumberController.text,
            newPhoneNumber: _newPhoneNumberController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Phone Number', style: TextStyle(color: Color(0xFF004D40), fontSize: 12, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            onPressed: () {
              CheckartisanNavigator.push(context, const ArtisanScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: BlocProvider(
          create: (context) => PhoneNumberBloc(useApi: false),
          child: BlocConsumer<PhoneNumberBloc, PhoneNumberState>(
            listener: (context, state) {
              if (state is PhoneNumberChanged) {
                CheckartisanNavigator.push(
                  context,
                  OTPVerificationArtisanScreen(
                    phoneNumber: _newPhoneNumberController.text,
                  ),
                );
              } else if (state is PhoneNumberError) {
                AnimatedSnackBar.rectangle(
                  'Error',
                  'Please Check Internet Connection',
                  type: AnimatedSnackBarType.error,
                ).show(context);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  _buildSmallTextField(
                    controller: _oldPhoneNumberController,
                    labelText: 'Old Phone Number',
                  ),
                  const SizedBox(height: 16),
                  _buildSmallTextField(
                    controller: _newPhoneNumberController,
                    labelText: 'New Phone Number',
                  ),
                  const SizedBox(height: 32),
                  if (state is PhoneNumberLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: 200, // Fixed width to align with the "LOGIN" button style in LoginClient
                      child: ElevatedButton(
                        onPressed: _changePhoneNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 8,
                        ),
                        child: const Text('GENERATE OTP'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
}

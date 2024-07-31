import 'package:check_artisan/VerificationArtisan/otp_verificationartisan.dart';
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
        title: const Text('Change Phone Number'),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtisanScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            TextField(
              controller: _oldPhoneNumberController,
              decoration: InputDecoration(
                labelText: 'Old Phone Number',
                hintStyle: const TextStyle(color: Color(0xFF004D40)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: const TextStyle(color: Color(0xFF004D40)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPhoneNumberController,
              decoration: InputDecoration(
                labelText: 'New Phone Number',
                hintStyle: const TextStyle(color: Color(0xFF004D40)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              style: const TextStyle(color: Color(0xFF004D40)),
            ),
            const SizedBox(height: 32),
            BlocConsumer<PhoneNumberBloc, PhoneNumberState>(
              listener: (context, state) {
                if (state is PhoneNumberChanged) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPVerificationArtisanScreen(
                        phoneNumber: _newPhoneNumberController.text,
                      ),
                    ),
                  );
                } else if (state is PhoneNumberError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is PhoneNumberLoading) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

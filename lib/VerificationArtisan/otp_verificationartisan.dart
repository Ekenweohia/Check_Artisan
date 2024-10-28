import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/profile/complete_profile_artisan.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class OTPVerificationArtisanEvent extends Equatable {
  const OTPVerificationArtisanEvent();

  @override
  List<Object> get props => [];
}

class RequestOTP extends OTPVerificationArtisanEvent {
  final String phoneNumber;

  const RequestOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTP extends OTPVerificationArtisanEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOTP(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class ResendOTP extends OTPVerificationArtisanEvent {
  final String phoneNumber;

  const ResendOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

abstract class OTPVerificationArtisanState extends Equatable {
  const OTPVerificationArtisanState();

  @override
  List<Object> get props => [];
}

class OTPVerificationArtisanInitial extends OTPVerificationArtisanState {}

class OTPVerificationArtisanLoading extends OTPVerificationArtisanState {}

class OTPVerificationArtisanSuccess extends OTPVerificationArtisanState {}

class OTPVerificationArtisanFailure extends OTPVerificationArtisanState {
  final String error;

  const OTPVerificationArtisanFailure(this.error);

  @override
  List<Object> get props => [error];
}

class OTPResent extends OTPVerificationArtisanState {}

class OTPVerificationArtisanBloc
    extends Bloc<OTPVerificationArtisanEvent, OTPVerificationArtisanState> {
  final bool useApi;

  OTPVerificationArtisanBloc({this.useApi = false})
      : super(OTPVerificationArtisanInitial()) {
    on<RequestOTP>(_onRequestOTP);
    on<VerifyOTP>(_onVerifyOTP);
    on<ResendOTP>(_onResendOTP);
  }

  Future<void> _onRequestOTP(
      RequestOTP event, Emitter<OTPVerificationArtisanState> emit) async {
    emit(OTPVerificationArtisanLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(
              'https://checkartisan.com/api/startup/phone/validate/${event.phoneNumber}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          emit(OTPResent());
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
          emit(OTPVerificationArtisanFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(OTPResent());
      }
    } catch (e) {
      emit(OTPVerificationArtisanFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOTP(
      VerifyOTP event, Emitter<OTPVerificationArtisanState> emit) async {
    emit(OTPVerificationArtisanLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(
              'https://checkartisan.com/api/startup/phone/validate/${event.phoneNumber}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'otp': event.otp,
          }),
        );

        if (response.statusCode == 200) {
          emit(OTPVerificationArtisanSuccess());
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
          emit(OTPVerificationArtisanFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        emit(OTPVerificationArtisanSuccess());
      }
    } catch (e) {
      emit(OTPVerificationArtisanFailure(e.toString()));
    }
  }

  Future<void> _onResendOTP(
      ResendOTP event, Emitter<OTPVerificationArtisanState> emit) async {
    emit(OTPVerificationArtisanLoading());

    try {
      if (useApi) {
        final response = await http.post(
          Uri.parse(
              'https://checkartisan.com/api/startup/phone/validate/${event.phoneNumber}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          emit(OTPResent());
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
          emit(OTPVerificationArtisanFailure(error));
        }
      } else {
        await Future.delayed(const Duration(seconds: 3));
        emit(OTPResent());
      }
    } catch (e) {
      emit(OTPVerificationArtisanFailure(e.toString()));
    }
  }
}

class OTPVerificationArtisanScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationArtisanScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  OTPVerificationArtisanScreenState createState() =>
      OTPVerificationArtisanScreenState();
}

class OTPVerificationArtisanScreenState
    extends State<OTPVerificationArtisanScreen> with CodeAutoFill {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode(); // Start listening for OTP automatically
  }

  @override
  void dispose() {
    cancel(); // Stop listening for OTP
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      _otpController1.text = code![0];
      _otpController2.text = code![1];
      _otpController3.text = code![2];
      _otpController4.text = code![3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => OTPVerificationArtisanBloc(useApi: false),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/otp.png',
                            width: constraints.maxWidth * 0.7,
                            height: constraints.maxWidth * 0.7,
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Enter the OTP sent to ${widget.phoneNumber}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _otpTextField(_otpController1, true),
                              _otpTextField(_otpController2, false),
                              _otpTextField(_otpController3, false),
                              _otpTextField(_otpController4, false),
                            ],
                          ),
                          const SizedBox(height: 30),
                          BlocConsumer<OTPVerificationArtisanBloc,
                              OTPVerificationArtisanState>(
                            listener: (context, state) {
                              if (state is OTPVerificationArtisanSuccess) {
                                AnimatedSnackBar.rectangle(
                                  'Success',
                                  'OTP Verified Successfully',
                                  type: AnimatedSnackBarType.success,
                                ).show(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CompleteProfile(),
                                  ),
                                );
                              } else if (state
                                  is OTPVerificationArtisanFailure) {
                                AnimatedSnackBar.rectangle(
                                  'Error',
                                  'Verification Failed: ${state.error}',
                                  type: AnimatedSnackBarType.error,
                                ).show(context);
                              } else if (state is OTPResent) {
                                AnimatedSnackBar.rectangle(
                                  'Success',
                                  'OTP Resent Successfully',
                                  type: AnimatedSnackBarType.success,
                                ).show(context);
                              }
                            },
                            builder: (context, state) {
                              if (state is OTPVerificationArtisanLoading) {
                                return const CircularLoadingWidget();
                              }
                              return Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Didn’t receive OTP? ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'RESEND',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF004D40),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context
                                                  .read<
                                                      OTPVerificationArtisanBloc>()
                                                  .add(ResendOTP(
                                                      widget.phoneNumber));
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: 150
                                          .h), // Space between text button and verify button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final otp = _otpController1.text +
                                            _otpController2.text +
                                            _otpController3.text +
                                            _otpController4.text;
                                        context
                                            .read<OTPVerificationArtisanBloc>()
                                            .add(VerifyOTP(
                                                widget.phoneNumber, otp));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF004D40),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.r),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('VERIFY'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller, bool autoFocus) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}

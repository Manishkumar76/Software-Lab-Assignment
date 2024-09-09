import 'dart:convert';

import 'package:farmer_eats/Authentication/Login/reset_passwordScreen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class VerifyOtpModel {
  final String otp;

  // Constructor to initialize the otp field
  VerifyOtpModel({required this.otp});

  // Factory method to create a new instance from a JSON object
  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      otp: json['otp'],
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
    };
  }
}

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String _otpcode = "";
  final int _otpLength = 6;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor:  Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(20),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          // Optional action for the Snackbar
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void verifyOtp() async {
    if (_otpcode.length == _otpLength) {
      var verifyOtpModel = VerifyOtpModel(otp: _otpcode);
      try {
        final response = await http.post(
            Uri.parse(Utills().verifyOtpUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(verifyOtpModel.toJson())

        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          if (responseData['success'] == "true") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
            );
          }
          else if(responseData['message']=="Unable to verify OTP, please try again."){
            _showErrorSnackbar(context, "Unable to verify OTP, please try again.");
          }
          else if( responseData['message']=="Invalid OTP."){
            _showErrorSnackbar(context, "Invalid OTP.");
          }
          else if( responseData['message']=="OTP cannot be empty."){
            _showErrorSnackbar(context, "OTP cannot be empty.");
          }
          else{
            _showErrorSnackbar(context, "An error occurred. Please try again.");
          }
        }
      } catch (e) {
        print(e);
        _showErrorSnackbar(context, "An error occurred. Please try again.");
      }
    } else {
      // Show error Snackbar if OTP is invalid
      _showErrorSnackbar(context, "Invalid OTP. Please try again.");
    }
  }



  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(220, 220, 220, 3),
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(230, 230, 240, 1),
      ),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Remember your password?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Handle Login tap
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFDD6C48), // Orange color for the text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Pinput(
                    length: _otpLength,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    validator: (s) {
                      return null;
                    },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onChanged: (value) {
                      if (value.length == _otpLength) {
                        _otpcode = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD6C48), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle Resend Code tap
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Colors.black,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

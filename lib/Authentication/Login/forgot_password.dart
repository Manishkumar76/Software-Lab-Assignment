import 'dart:convert';
import 'package:farmer_eats/Authentication/Login/verifyOTPScreen.dart';
import 'package:farmer_eats/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model
class ForgotPasswordModel {
  final String mobile;

  ForgotPasswordModel({required this.mobile});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}

// Screen
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mobileController = TextEditingController();
  var warning="";
  void setWarning(String message){
    setState(() {
      warning=message;
    });
  }
  void sendCode() async {
    var forgotPasswordModel = ForgotPasswordModel(
      mobile: mobileController.text,
    );

    if (mobileController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse(Utills().forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(forgotPasswordModel.toJson()),
      );

      // Handling different responses
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == "true") {
          // OTP sent successfully
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VerifyOTPScreen()),
          );
        } else {
          // Handling specific error messages
          String message = responseData['message'];
          if (message == "Couldn't send an OTP, please try again.") {
            _showErrorDialog("Couldn't send an OTP, please try again.");
          } else if (message == "Account with this mobile number does not exist.") {
            _showErrorDialog("Account with this mobile number does not exist.");
          }
        }
      } else {
        // Handle other status codes or unexpected errors
        _showErrorDialog("An unexpected error occurred. Please try again later.");
      }
    } else {
      _showErrorDialog("Please enter your mobile number.");
    }
     if(mobileController.text.isEmpty){
      setWarning("Mobile number must be required!");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
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
                      // Handle Create Account tap
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFDD6C48),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  hintText: 'Phone Number',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: warning==""?null:Text(warning,style: const TextStyle(fontSize: 12,color: Colors.red),),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: sendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD6C48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Send Code',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
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

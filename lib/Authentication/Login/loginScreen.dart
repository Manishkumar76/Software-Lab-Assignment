import 'dart:convert';
import 'package:farmer_eats/Authentication/SingnUp/SignUpScreen.dart';
import 'package:farmer_eats/constants.dart';
import 'package:farmer_eats/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var warning = "";
  bool isLoading = false;

  void setWarning(String message) {
    setState(() {
      warning = message;
    });
  }

  Future<void> _authenticateUser(
      String type,
      String? email,
      String? password,
      String? socialId,
      ) async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(Utills().loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email ?? "",
          "password": password ?? "",
          "role": "farmer",
          "device_token": "0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx",
          "type": type,
          "social_id": socialId ?? "",
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == 'true') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MyHomePage(title: "Farmer Eats"),
          ),
        );
      } else {
        _showErrorMessage(responseData['message']);
      }
    } catch (error) {
      _showErrorMessage('An unexpected error occurred.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setWarning("Every field must be filled!");
    } else {
      setWarning("");
      await _authenticateUser("email", emailController.text, passwordController.text, null);
    }
  }

  Future<void> _loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    await _authenticateUser("google", user.user?.email, null, user.user?.uid);
  }

  Future<void> _loginWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      await _authenticateUser("facebook", user.user?.email, null, user.user?.uid);
    } else {
      _showErrorMessage("Facebook login failed.");
    }
  }

  Future<void> _loginWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    final oAuthProvider = OAuthProvider("apple.com");
    final appleCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(appleCredential);
    await _authenticateUser("apple", user.user?.email, null, user.user?.uid);
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
                'Welcome back!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('New here?', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                    },
                    child: const Text('Create account', style: TextStyle(fontSize: 16, color: Color(0xFFDD6C48), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Email Address',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Password',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  suffixIcon: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword()));
                    },
                    child: const Text('Forgot?'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD6C48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: Text('or login with', style: TextStyle(fontSize: 14, color: Colors.grey))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialLoginButton(icon: Icons.g_mobiledata, color: Colors.red, onPressed: _loginWithGoogle),
                  SocialLoginButton(icon: Icons.apple, color: Colors.black, onPressed:(){
                    _loginWithApple();
                    }
                  ),
                  SocialLoginButton(icon: Icons.facebook, color: Colors.blue, onPressed: _loginWithFacebook),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}

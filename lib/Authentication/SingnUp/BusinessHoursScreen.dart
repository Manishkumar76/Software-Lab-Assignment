import 'dart:convert';

import 'package:farmer_eats/Authentication/SingnUp/afterSignupScreen.dart';
import 'package:farmer_eats/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../Models/user_model.dart';


class BusinessHoursScreen extends StatefulWidget {
  const BusinessHoursScreen({Key? key}) : super(key: key);

  @override
  _BusinessHoursScreenState createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  final List<String> days = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];
  final Map<String, List<String>> timeSlots = {
    '8:00am - 10:00am': [],
    '10:00am - 1:00pm': [],
    '1:00pm - 4:00pm': [],
    '4:00pm - 7:00pm': [],
    '7:00pm - 10:00pm': [],
  };

  String selectedDay = 'M';


  Future<void> signUp(UserData userData) async {
    try {
      final response = await http.post(
        Uri.parse(Utills().registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData.toJson()),
      );
      if (response.statusCode == 200) {
        final result = response.body;

        // Handle different server responses based on `success` field
        if (result.contains('"success": "true"')) {

          // Successful registration
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AfterSignupScreen()));
        } else if (result.contains('"message": "All fields are required."')) {
          // Handle missing fields
          _showErrorMessage("All fields are required.");
        } else if (result.contains('"message": "Email already exists."')) {
          // Handle existing email
          _showErrorMessage("Email already exists.");
        } else {
          // Handle general registration failure
          _showErrorMessage("Registration failed. Please try again.");
        }
      }

      else {
        _showErrorMessage("Access denied! unauthorized user.");
      }
    } catch (e) {
      _showErrorMessage("An error occurred. Please try again.");
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Signup 4 of 4",
              style: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Business Hours",
              style: TextStyle(fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose the hours your farm is open for pickups. This will allow customers to order deliveries.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selectedDay == day
                          ? const Color(0xFFDD6C48)
                          : Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: selectedDay == day ? Colors.white : Colors
                              .black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: timeSlots.keys.map((slot) {
                  final isSelected = userData.businessHours[selectedDay]
                      ?.contains(slot) ?? false;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          userData.removeBusinessHour(selectedDay, slot);
                        } else {
                          userData.updateBusinessHours(selectedDay, slot);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15,
                          horizontal: 20),
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back)),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      await signUp(userData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDD6C48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Signup',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
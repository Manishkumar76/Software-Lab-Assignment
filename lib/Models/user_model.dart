import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String fullName;
  String email;
  String phone;
  String password;
  String role;
  String businessName;
  String informalName;
  String address;
  String city;
  String state;
  int? zipCode;
  String registrationProof;
  Map<String, List<String>> businessHours;
  String deviceToken;
  String type;
  String socialId;

  UserData({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.role = 'farmer',
    this.businessName = '',
    this.informalName = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zipCode,
    this.registrationProof = '',
    Map<String, List<String>>? businessHours,
    this.deviceToken = '',
    this.type = 'email',
    this.socialId = '',
  }) : businessHours = businessHours ?? {};

  factory UserData.fromJson(Map<String, dynamic> json) {
    // Parsing nested businessHours from JSON
    Map<String, List<String>> parsedBusinessHours = {};
    if (json['businessHours'] != null) {
      parsedBusinessHours = Map<String, List<String>>.from(json['businessHours']).map(
            (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      );
    }

    return UserData(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'farmer',
      businessName: json['businessName'] ?? '',
      informalName: json['informalName'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] != null ? int.tryParse(json['zipCode'].toString()) : null,
      registrationProof: json['registrationProof'] ?? '',
      businessHours: parsedBusinessHours,
      deviceToken: json['deviceToken'] ?? '',
      type: json['type'] ?? 'email',
      socialId: json['socialId'] ?? '',
    );
  }

  void updateBusinessHours(String day, String value) {
    if (businessHours.containsKey(day)) {
      businessHours[day]!.add(value);
    } else {
      businessHours[day] = [value];
    }
    notifyListeners();
  }

  void removeBusinessHour(String day, String value) {
    if (businessHours.containsKey(day)) {
      businessHours[day]!.remove(value);
      if (businessHours[day]!.isEmpty) {
        businessHours.remove(day);
      }
      notifyListeners();
    }
  }

  void updateFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void updateRegistrationProof(String path) {
    registrationProof = path;
    notifyListeners();
  }

  void updateBusinessName(String name) {
    businessName = name;
    notifyListeners();
  }

  void updateInformalName(String name) {
    informalName = name;
    notifyListeners();
  }

  void updateAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  void updateCity(String city) {
    this.city = city;
    notifyListeners();
  }

  void updateState(String state) {
    this.state = state;
    notifyListeners();
  }

  void updateZipCode(int zipCode) {
    this.zipCode = zipCode;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'businessName': businessName,
      'informalName': informalName,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'registrationProof': registrationProof,
      'businessHours': businessHours.map((key, value) => MapEntry(key, value)),
      'deviceToken': deviceToken,
      'type': type,
      'socialId': socialId,
    };
  }
}

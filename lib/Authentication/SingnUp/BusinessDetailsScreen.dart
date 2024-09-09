import 'package:farmer_eats/Authentication/SingnUp/verificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/user_model.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  TextEditingController businessContoller = TextEditingController();
  TextEditingController InformalContoller = TextEditingController();
  TextEditingController adressContoller = TextEditingController();
  TextEditingController cityContoller = TextEditingController();
  TextEditingController StateContoller = TextEditingController();
  TextEditingController ZipcodeContoller = TextEditingController();

  var warning = "";
  void setWarning(String message) {
    setState(() {
      warning = message;
    });
  }

  void continueToNext() {
    if (businessContoller.text.isEmpty ||
        InformalContoller.text.isEmpty ||
        adressContoller.text.isEmpty ||
        cityContoller.text.isEmpty ||
        StateContoller.text.isEmpty ||
        ZipcodeContoller.text.isEmpty) {
      setWarning("Every Fields are Required!");
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const VerificationScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text('Signup 2 of 4',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey)),
              const SizedBox(height: 4),
              const Text('Farm Info',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              const SizedBox(height: 20),
              TextField(
                controller: businessContoller,
                onChanged: (value) {
                  userData.updateBusinessName(value);
                  setState(() {
                    businessContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.business),
                  hintText: 'Business Name',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: InformalContoller,
                onChanged: (value) {
                  userData.updateInformalName(value);
                  setState(() {
                    InformalContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.store_mall_directory),
                  hintText: 'Informal Name',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: adressContoller,
                onChanged: (value) {
                  userData.updateAddress(value);
                  setState(() {
                    adressContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on),
                  hintText: 'Address',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityContoller,
                onChanged: (value) {
                  userData.updateCity(value);
                  setState(() {
                    cityContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city),
                  hintText: 'City',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: StateContoller,
                onChanged: (value) {
                  userData.updateState(value);
                  setState(() {
                    StateContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.map),
                  hintText: 'State',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ZipcodeContoller,
                onChanged: (value) {
                  userData.updateZipCode(int.parse(value));
                  setState(() {
                    ZipcodeContoller = value as TextEditingController;
                  });
                  setWarning("");
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.local_post_office),
                  hintText: 'Zip Code',
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
                child: warning == ""
                    ? null
                    : Text(
                        warning,
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        continueToNext();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDD6C48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue',
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
      ),
    );
  }
}

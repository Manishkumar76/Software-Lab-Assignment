import 'package:farmer_eats/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Login/loginScreen.dart';
import 'BusinessDetailsScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController repassword= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController name= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController email= TextEditingController();
  String warning="";
  void changeWarningMessage(String value){
    setState(() {
      warning = value;
    });
  }
  void continueToNext(){
    if(repassword.text!=password.text){
      changeWarningMessage("The passwords does not matched!");
    }
    else if( email.text.isEmpty|| phone.text.isEmpty|| name.text.isEmpty||password.text.isEmpty|| repassword.text.isEmpty){
      changeWarningMessage("Every fields are required!");
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const BusinessDetailsScreen()));
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
             const Text('Signup1 of 4',style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),),
              const SizedBox(height: 4,),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialLoginButton(icon: Icons.g_mobiledata, color: Colors.red, onPressed: (){}),
                  SocialLoginButton(

                    icon: Icons.apple,
                    color: Colors.black, // Apple color
                    onPressed: () {
                      // Handle Apple login
                    },
                  ),
                  SocialLoginButton(
                    icon: Icons.facebook,
                    color: Colors.blue, // Facebook color
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Center(
                child: Text(
                  'or signup with',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: name,
                onChanged: (value){
                  userData.updateFullName(value);
                  if(warning!=""){
                    changeWarningMessage("");
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                  hintText: 'Full Name',
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
                controller: email,
                onChanged: (value){
                  userData.email=value;
                  if(warning!=""){
                    changeWarningMessage("");
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Email Address',
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
                controller: phone,
                onChanged: (value){
                  userData.phone=value;
                  if(warning!=""){
                    changeWarningMessage("");
                  }
                }
                ,
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
              const SizedBox(height: 10),

              TextField(
                controller: password,
                onChanged: (value){
                  if(warning!=""){
                    changeWarningMessage("");
                  }
                  userData.password=value;
                setState(() {
                password=value as TextEditingController;
                });
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Password',
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
                controller: repassword ,
                onChanged:(value){
                  if(warning!=""){
                    changeWarningMessage("");
                  }
                  setState(() {
                    repassword=value as TextEditingController;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Re-enter Password',
                  filled: true,
                  fillColor: const Color(0xFFEAE8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Text(warning==""?"":warning,style: const TextStyle(fontSize: 12,color: Colors.red),textAlign: TextAlign.center ,),
              const SizedBox(height: 20),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
                  }, child: const Text("Login",style: TextStyle(color: Colors.black),)),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                     continueToNext();
                      },
                      style: ElevatedButton.styleFrom(

                        backgroundColor: const Color(0xFFDD6C48), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
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

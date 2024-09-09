import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmer_eats/Authentication/Login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../main.dart';
import 'onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  List<Onboarding> OnboardingData= [
    Onboarding(
      imagePath: 'assets/images/onboarding1.svg', // Update this to the path of your first image
      title: 'Quality',
      description: 'Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain.',
      color: Colors.green,
    ),
    Onboarding(
      imagePath: 'assets/images/onboarding2.svg', // Update this to the path of your second image
      title: 'Convenient',
      description: 'Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.',
      color: Colors.orange,
    ),
    Onboarding(
      imagePath: 'assets/images/onboarding3.svg', // Update this to the path of your third image
      title: 'Local',
      description: 'We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time.',
      color: Colors.yellow,
    ),
  ];

   var currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

        decoration: BoxDecoration(
          color: OnboardingData[currentIndex].color,
        ),
        child: Stack(

          children: [
             SizedBox(
                width: double.infinity,
                height: double.infinity,
                child:SvgPicture.asset(
                  OnboardingData[currentIndex].imagePath
                )),
            Positioned(
                bottom:0,
              left:0,
              right: 0,


              child: Container(

                decoration: const BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    _buildCarouselSlider(OnboardingData),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     for(int i=0;i<OnboardingData.length;i++)...[
                       Row(
                         children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                             height: 6,
                             width:i==currentIndex? 10:6,

                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
                               color:i==currentIndex? Colors.black:Colors.grey.shade500,),
                           ),

                           const SizedBox(width: 3,)
                         ],
                       ),

                     ],
                    ],),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:OnboardingData[currentIndex].color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const MyHomePage(title: 'FarmerEats')));
                      },
                      child: const Text('Join the movement!',style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(height: 10,),
                    TextButton(
                      onPressed: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,)
                  ],
                ),
              ),)
          ],
        ),
      )
    );
  }
  Widget _buildCarouselSlider(List<Onboarding> data) {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          viewportFraction: 0.8,
          initialPage: 0,
          reverse: false,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
    setState(() {
     currentIndex=index;
    });
          }),
      items: data.map((d) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: d.color,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    d.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),


                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}


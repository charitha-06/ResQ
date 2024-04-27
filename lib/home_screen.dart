import 'package:flutter/material.dart';
import 'package:res_q/widgets/home_widgets/custom_appBar.dart';
import 'package:res_q/widgets/home_widgets/nearby.dart';
import 'package:res_q/widgets/home_widgets/sendLocation/sendLocation.dart';
import 'package:res_q/widgets/home_widgets/slider.dart';
import 'package:res_q/widgets/home_widgets/Emergency.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(int.parse('0xFFb1cbf2')), // Start color
              Color(int.parse('0xFFFFFFFF')), // End color
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch widgets to full width
                children: [
                  custom_appBar(),
                  Emergency(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      "Latest Articles",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  slider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),

                    child: Text(
                      "Explore Nearby Services",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Nearby(),
                  SendLocation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

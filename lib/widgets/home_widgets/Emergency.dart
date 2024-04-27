import 'package:flutter/material.dart';
import 'package:res_q/widgets/home_widgets/emergencies/activeEmergency.dart';
import 'emergencies/policeEmergency.dart';
import 'emergencies/AmbulanceEmergency.dart';
import 'emergencies/childEmergency.dart';
import 'emergencies/FirebrigadeEmergency.dart';
class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          AmbulanceEmergency(),
          FireEmergency(),
          ChildEmergency(),
          ActiveEmergency(),
        ],
      ),
    );
  }
}
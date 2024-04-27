import 'package:flutter/material.dart';
import 'package:res_q/widgets/home_widgets/nearbyPlaces/HospitalNearbyLocation.dart';
import 'package:res_q/widgets/home_widgets/nearbyPlaces/fireStationNearbyLocation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'nearbyPlaces/pharmacyNaerbyLocation.dart';
import 'nearbyPlaces/policeStationLocation.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Nearby extends StatelessWidget {
  const Nearby({Key? key}) : super(key: key);
  static Future<void> openMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';


     final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'something went wrong! call emergency number');
     }
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 90,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(onMapFunction: openMap),
          HospitalCard(onMapFunction: openMap),
          PharmacyCard(onMapFunction: openMap),
          FireStationCard(onMapFunction: openMap),

        ],
      ),

    );
  }
}


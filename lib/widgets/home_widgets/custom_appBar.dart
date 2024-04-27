import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class custom_appBar extends StatelessWidget{
  const custom_appBar ({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.topLeft, // Align the text to the top left corner
      padding: EdgeInsets.all(5),

      child: Text ('ResQ',
        style: GoogleFonts.lobster(
            fontSize: 42,
          color: Colors.black,
        ),
      ),
    );
  }
}
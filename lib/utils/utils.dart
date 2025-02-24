import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void moveScreen(BuildContext context, Widget screen,
    {bool isPushReplacement = false}) {
  if (isPushReplacement) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}

AppBar buildAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    centerTitle: true,
  );
}

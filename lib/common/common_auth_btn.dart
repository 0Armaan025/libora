import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CommonAuthBtn extends StatefulWidget {
  final Color bgColor;
  final Color textColor;
  final String text;
  final VoidCallback onTap;
  const CommonAuthBtn(
      {super.key,
      required this.onTap,
      required this.text,
      this.textColor = Colors.white,
      this.bgColor = const Color.fromRGBO(44, 45, 50, 1)});

  @override
  State<CommonAuthBtn> createState() => _CommonAuthBtnState();
}

class _CommonAuthBtnState extends State<CommonAuthBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: HexColor("#000000").withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.poppins(
              color: widget.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

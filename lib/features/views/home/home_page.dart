import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/utils/theme/Pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                height: size.height * 0.4,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Pallete().buttonColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                // padding: const EdgeInsets.only(left: 20, top: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 18),
                  child: Row(
                    children: [
                      Column(children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/images/logo.png"),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good evening, Armaan! 👋",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "12th December, 2022",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/active_space_tile.dart';
import 'package:libora/common/common_navbar.dart';
import 'package:libora/common/continue_reading_tile.dart';
import 'package:libora/features/views/home/home_page_content.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/constants.dart'; // Import constants.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = selectedIndex; // Get initial index

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: CommonNavbar(
        selectedIndex: myIndex, 
        onTap: _onItemTapped, // Update index when tapped
      ),
      backgroundColor: HexColor("#f9f5ea"),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePageContent(), // Page 0
         Container(),
         Container(),
        ],
      ),
    );
  }
}

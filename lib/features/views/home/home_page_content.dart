import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/active_space_tile.dart';
import 'package:libora/common/continue_reading_tile.dart';
import 'package:libora/utils/theme/Pallete.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 18),
                    child: Row(
                      children: [
                        Column(children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/images/logo.png"),
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
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      "Continue Reading",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  ContinueReadingTile(
                      imageUrl:
                          'https://i.pinimg.com/1200x/57/95/44/5795443bab333f614ffd7900defcb61e.jpg',
                      bookName: "The literal prison",
                      authorName: 'Armaan'),
                ],
              ),
            ),

            // vertical spacing

            Container(
              height: size.height * 0.02,
              color: HexColor("#f9f5ea"),
            ),

            SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: Container(
                color: HexColor("#f9f5ea"),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Books(I want y'all to try!)",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Number of books
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    height: size.height * 0.2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://via.placeholder.com/150'), // Replace with your book image URL
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Book Name $index",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Author Name",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ActiveSpacesTile(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section
                Container(
                  width: double.infinity,
                  height: height * 0.44,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Pallete().buttonColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: width * 0.07,
                              backgroundImage: const AssetImage(
                                  "assets/images/logo.png"), // Adjust logo size
                            ),
                            SizedBox(width: width * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good evening, Armaan! 👋",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                  ),
                                ),
                                Text(
                                  "12th December, 2022",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade500,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "A random quote",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: width * 0.06,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ContinueReadingTile(
                          imageUrl:
                              'https://i.pinimg.com/1200x/57/95/44/5795443bab333f614ffd7900defcb61e.jpg',
                          bookName: "The Literal Prison",
                          authorName: 'Armaan',
                        ),
                      ],
                    ),
                  ),
                ),

                // Vertical spacing
                Container(height: height * 0.02, color: HexColor("#f9f5ea")),

                // Book Recommendation Section
                Container(
                  width: double.infinity,
                  color: HexColor("#f9f5ea"),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                        "Books (I want y'all to try!)",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.32,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: width * 0.04),
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.all(width * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width * 0.4,
                                      height: height * 0.2,
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://cdn-icons-png.flaticon.com/128/1999/1999625.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      "Book Name $index",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Author Name",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade700,
                                        fontSize: width * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: ActiveSpacesTile(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

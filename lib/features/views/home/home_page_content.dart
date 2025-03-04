import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/active_space_tile.dart';
import 'package:libora/common/continue_reading_tile.dart';
import 'package:intl/intl.dart'; // Import this
import 'package:libora/features/controllers/auth_controller.dart';

import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String username = "";
  String formattedDate = ""; // Store the formatted date
  String greeting = "";
  String profileImage = "";

  List<String> coverImages = [
    "https://imgs.search.brave.com/NgzTuJyzanpPTR01qfRLSpgm9443rUGt4YN_U5VYbf4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/cG9yY2hsaWdodGJv/b2tzLmNvbS9hc3Nl/dHMvaW1hZ2VzL2Jv/b2tzLzQvMjQvNzI0/LzM3MjQvOTc4MTU4/NTA5MzcyNC5qcGc_/dz0xMDAwJnNjYWxl/PWJvdGgmbW9kZT1j/cm9wJnU9NjM4NzUz/MTM3NzMzOTcwMDAw",
    "https://imgs.search.brave.com/2mz26amRNRJbEbixA4LIgYaIuMgTSCn2v51lOPJ08j8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9iYXJv/bmZpZy5jb20vY2Ru/L3Nob3AvcHJvZHVj/dHMvYXRvbWljLWhh/Yml0c19idXktdmFy/aWFudF8wMS5qcGc_/dj0xNjA5MTk3NjUw/JndpZHRoPTE0MDA",
    "https://imgs.search.brave.com/qkxc5ePjzRMn_LcrWRqDK5IN-G6Tzc6Sc-q97B_Y88o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NDF1NFZlbzNBWkwu/anBn",
    "https://imgs.search.brave.com/o85FGZdf6q43ufrMMcjsdW9tCM8njvlwOWpPYc4xjjg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NDFmK095d2dVY0wu/anBn"
  ];

  List<String> books = [
    "The power of your subsconscious mind",
    "Atomic Habits",
    "The art of reading people",
    "RD SHARMA MATH CLASS 9"
  ];
  List<String> authors = [
    "Joseph Murphy",
    "James clear",
    "Ian Tuhovsky",
    "RD SHARMA, JK"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    getCurrentDate(); // Call function to format date
  }

  void getCurrentDate() {
    DateTime now = DateTime.now();

    // Format date & time (Example: "03 March, 2025 | 09:15 AM")
    String formattedDateTime =
        DateFormat("dd MMMM, yyyy | hh:mm a").format(now);

    // Determine greeting based on hour
    int hour = now.hour;
    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    setState(() {
      formattedDate = formattedDateTime;
    });
  }

  getUserName() {
    getTheDamnName();
  }

  getTheDamnName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    setState(() {
      username = name!;
    });

    AuthController controller = AuthController();
    final user = await controller.getUserDetails(context, username);
    setState(() {
      profileImage = user?['user']?['profile_image'] ?? '';
      print('profile image is $profileImage');
    });
  }

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
                              backgroundImage: NetworkImage(
                                  profileImage), // Adjust logo size
                            ),
                            SizedBox(width: width * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$greeting, ${username.isNotEmpty ? username : 'User'}! 👋",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: width * 0.046,
                                  ),
                                ),
                                Text(
                                  formattedDate,
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
                      InkWell(
                        onTap: () {
                          showSnackBar(
                              context, "Nah nah nah, create a space first :D");
                        },
                        child: SizedBox(
                          height: height * 0.35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: books.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.4,
                                        height: height * 0.2,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                coverImages[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      Text(
                                        "${books[index]}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.034,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        authors[index],
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

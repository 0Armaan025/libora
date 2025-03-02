import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/common_navbar.dart';
import 'package:libora/features/views/home/home_page_content.dart';
import 'package:libora/features/views/search/search_view.dart';
import 'package:libora/features/views/profile/profile_view.dart';
import 'package:libora/features/views/spaces_view/spaces_view.dart';
import 'package:libora/utils/constants.dart';
import 'package:libora/utils/utils.dart'; // Import constants.dart

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
      appBar: buildAppBar("Libora"),
      bottomNavigationBar: CommonNavbar(
        selectedIndex: myIndex,
        onTap: _onItemTapped, // Update index when tapped
      ),
      backgroundColor: HexColor("#f9f5ea"),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePageContent(), // Page 0
          UserSearchView(),
          // BookDetailScreen(
          //   bookName: "The Great Gatsby",
          //   authorName: "F. Scott Fitzgerald",
          //   description:
          //       "The Great Gatsby is a 1925 novel by American writer F. Scott Fitzgerald. Set in the Jazz Age on Long Island, the novel depicts narrator Nick Carraway's interactions with mysterious millionaire Jay Gatsby and Gatsby's obsession to reunite with his former lover, Daisy Buchanan.",
          //   imageUrl:
          //       "https://m.media-amazon.com/images/I/71FTb9X6wsL._AC_UF1000,1000_QL80_.jpg",
          // ),
          SpacesView(),
          ProfilePage(
            username: "0Armaan025", // Change to test with/without DEV badge
            imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
            followers: 342,
            following: 167,
            booksRead: 27,
            isCurrentUser: true, // Change to false to test follow button
          ),
        ],
      ),
    );
  }
}

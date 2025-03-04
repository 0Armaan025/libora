import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/common_navbar.dart';
import 'package:libora/features/views/home/home_page_content.dart';
import 'package:libora/features/views/search/search_view.dart';
import 'package:libora/features/views/profile/profile_view.dart';
import 'package:libora/features/views/spaces_view/spaces_view.dart';
import 'package:libora/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = selectedIndex;
  String _username = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsernameWithTimeout();
  }

  Future<void> _loadUsernameWithTimeout() async {
    try {
      // Set a timeout of 3 seconds
      final username = await _fetchUsername().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print("Username fetch timed out");
          return "User";
        },
      );

      if (mounted) {
        setState(() {
          _username = username;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading username: $e");
      if (mounted) {
        setState(() {
          _username = "User";
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") ?? "User";
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Libora"),
      bottomNavigationBar: CommonNavbar(
        selectedIndex: myIndex,
        onTap: _onItemTapped,
      ),
      backgroundColor: HexColor("#f9f5ea"),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "Loading everything...",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : IndexedStack(
              index: selectedIndex,
              children: [
                HomePageContent(),
                UserSearchView(),
                SpacesView(),
                ProfilePage(
                  username: _username,
                ),
              ],
            ),
    );
  }
}

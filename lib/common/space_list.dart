import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/views/book_community/book_community_view.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';
import 'package:libora/features/controllers/auth_controller.dart'; // Assuming this is where AuthController is defined

class SpaceList extends StatefulWidget {
  final String spaceName;
  final List<String> people; // Assuming this is a list of usernames

  const SpaceList({
    super.key,
    required this.spaceName,
    required this.people,
  });

  @override
  State createState() => _SpaceListState();
}

class _SpaceListState extends State<SpaceList> {
  List<String> profileImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileImages();
  }

  Future<void> _fetchProfileImages() async {
    try {
      // Create a list to store profile image URLs
      List<String> images = [];

      // Fetch user details for each person in the space
      for (String username in widget.people) {
        try {
          // Assuming getUserDetails returns a user object with a profileImageUrl
          var userDetails =
              await AuthController().getUserDetails(context, username);
          if (userDetails != null && userDetails["profileImage"] != null) {
            images.add(userDetails['profileImage']);
          }
        } catch (e) {
          print('Error fetching profile image for $username: $e');
        }
      }

      // Update state if the widget is still mounted
      if (mounted) {
        setState(() {
          profileImages = images;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile images: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Space Name
          Text(
            widget.spaceName,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10), // Spacer

          // Profile Pictures List
          if (_isLoading)
            const CircularProgressIndicator()
          else
            SizedBox(
              height: 50, // Limit height to avoid infinite constraints
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Set horizontal scrolling
                shrinkWrap: true,
                itemCount: profileImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(profileImages[index]),
                      // Optional: Add a placeholder or error image
                      backgroundColor: Colors.grey[200],
                      child: profileImages[index].isEmpty
                          ? Icon(Icons.person, color: Colors.grey[600])
                          : null,
                    ),
                  );
                },
              ),
            ),

          const SizedBox(width: 10), // Spacer

          // Join Button
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  moveScreen(context, BookCommunityScreen(code: "123"));
                },
                child: Container(
                  width: size.width * 0.15,
                  height: 40,
                  margin: const EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Pallete().buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Join",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

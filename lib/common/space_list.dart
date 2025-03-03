import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/views/book_community/book_community_view.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';

class SpaceList extends StatefulWidget {
  final String spaceName;
  final List<String> profilePictures;

  const SpaceList({
    super.key,
    required this.spaceName,
    required this.profilePictures,
  });

  @override
  State<SpaceList> createState() => _SpaceListState();
}

class _SpaceListState extends State<SpaceList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
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
        SizedBox(
          height: 50, // Limit height to avoid infinite constraints
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Set horizontal scrolling
            shrinkWrap: true,
            itemCount: widget.profilePictures.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.profilePictures[index]),
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
    );
  }
}

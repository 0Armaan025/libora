import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ContinueReadingTile extends StatefulWidget {
  final String imageUrl;
  final String bookName;
  final String authorName;

  const ContinueReadingTile({
    super.key,
    required this.imageUrl,
    required this.bookName,
    required this.authorName,
  });

  @override
  State<ContinueReadingTile> createState() => _ContinueReadingTileState();
}

class _ContinueReadingTileState extends State<ContinueReadingTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.17,
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: HexColor("#fffeff"),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.04, // Set explicit height for image
            width: size.width * 0.2, // Set explicit width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12), // Spacer for better layout
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // verticl spacer

                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.bookName,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevents overflow
                ),
                const SizedBox(height: 4),
                Text(
                  widget.authorName.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(
                  height: 8,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  icon: Icon(Icons.book, color: Colors.green),
                  label: Text(
                    'Read',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

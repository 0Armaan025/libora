import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ContinueReadingTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9, // More flexible width
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.04,
      ),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: HexColor("#fffeff"),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book Cover
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: size.width * 0.25, // Scales with screen width
              height: size.height * 0.15, // Scales with screen height
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: size.width * 0.04), // Dynamic spacing

          // Book Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookName,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.05, // Scales with width
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevents overflow
                ),
                SizedBox(height: size.height * 0.005),

                Text(
                  authorName.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: size.width * 0.04, // Scales with width
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: size.height * 0.01),

                // Read Button
                TextButton.icon(
                  onPressed: () {
                    // Add navigation or reading functionality here
                  },
                  icon: Icon(
                    Icons.book,
                    color: Colors.green,
                    size: size.width * 0.05, // Adaptive icon size
                  ),
                  label: Text(
                    'Read',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                        color: Colors.grey, width: 1), // Thin grey border
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

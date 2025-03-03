import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';

class ContinueReadingTile extends StatelessWidget {
  final List<Map<String, String>> quotes = [
    {
      "text": "The only way to do great work is to love what you do.",
      "author": "Armaan"
    },
    {
      "text": "Life is what happens when you're busy making other plans.",
      "author": "Armaan"
    },
    {
      "text":
          "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Armaan"
    },
    {
      "text": "In the middle of difficulty lies opportunity.",
      "author": "Armaan"
    },
    {
      "text": "The best way to predict the future is to create it.",
      "author": "Armaan"
    },
    {"text": "Simplicity is the ultimate sophistication.", "author": "Armaan"},
    {
      "text": "Yesterday is history, tomorrow is a mystery, today is a gift.",
      "author": "Armaan"
    },
  ];

  ContinueReadingTile({
    super.key,
    // Keeping required parameters for compatibility but not using them
    required String imageUrl,
    required String bookName,
    required String authorName,
  });

  Map<String, String> getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final randomQuote = getRandomQuote();

    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.04,
      ),
      padding: EdgeInsets.all(size.width * 0.04),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${randomQuote["text"]}"',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: size.width * 0.045,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "~ ${randomQuote["author"]}",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
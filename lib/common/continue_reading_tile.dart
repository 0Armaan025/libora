import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';

class ContinueReadingTile extends StatelessWidget {
  final List<Map<String, String>> quotes = [
    {
      "text": "Don't judge a book by its cover, this is not about books",
      "author": "Armaan"
    },
    {"text": "Incomplete information is always dangerous", "author": "Armaan"},
    {
      "text": "People can go from people you know to don't, but books won't",
      "author": "Armaan"
    },
    {
      "text": "The best way to predict the future is to create it.",
      "author": "Armaan"
    },
    {
      "text":
          "The only realization that we have in the future may or may not be the regret we have today",
      "author": "Armaan"
    },
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
              fontSize: size.width * 0.04,
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

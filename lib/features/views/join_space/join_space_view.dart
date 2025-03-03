import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:libora/features/views/book_community/book_community_view.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinSpaceScreen extends StatefulWidget {
  const JoinSpaceScreen({super.key});

  @override
  State<JoinSpaceScreen> createState() => _JoinSpaceScreenState();
}

class _JoinSpaceScreenState extends State<JoinSpaceScreen> {
  final _spaceCodeController = TextEditingController();

  void _joinSpace() async {
    if (_spaceCodeController.text.isEmpty ||
        _spaceCodeController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 3-digit code")),
      );
      return;
    }

    ApiService service = ApiService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String person = prefs.getString('name') ?? '';
    final space =
        await service.joinSpace(context, person, _spaceCodeController.text);
    moveScreen(context, BookCommunityScreen(code: space.code));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _spaceCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor("#3e7bfa");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Join Space",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Space Code",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _spaceCodeController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                hintText: "Enter 3-digit code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _joinSpace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Join Space",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:libora/features/views/book_community/book_community_view.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSpaceScreen extends StatefulWidget {
  const CreateSpaceScreen({super.key});

  @override
  State createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends State {
  final _spaceNameController = TextEditingController();
  final _usernameController = TextEditingController();
  String? _spaceCode;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
    });
  }

  Future _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
  }

  void _createSpace() async {
    if (_spaceNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter space name ")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a random 3-digit code
      final randomCode = (100 + (DateTime.now().millisecond % 900)).toString();

      // Save username for future use

      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name');

      // Create space on the server
      final space = await _apiService.createSpace(
        name!,
        _spaceNameController.text.trim(),
        randomCode,
      );

      setState(() {
        _spaceCode = randomCode;
        _isLoading = false;
      });

      // Show success dialog with the space code
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Space Created!",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your space code is:",
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  ClipboardData data = ClipboardData(text: _spaceCode!);
                  Clipboard.setData(data);
                },
                child: Text(
                  _spaceCode!,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Share this code with others to join your space.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to space detail screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookCommunityScreen(
                      code: _spaceCode!,
                    ),
                  ),
                );
              },
              child: Text(
                "Enter Space",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating space: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Space",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Pallete().bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Space Name",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _spaceNameController,
              decoration: InputDecoration(
                hintText: "Enter space name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createSpace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Create Space",
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

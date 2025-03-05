import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/common/common_auth_btn.dart';
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/views/auth/log_in_page.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String selectedAvatar =
      'https://cdn-icons-png.flaticon.com/128/1999/1999625.png';

  bool _isObscure = true;
  bool _isAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // List of avatars (Replace with your own image URLs if needed)
  final List<String> avatarOptions = [
    'https://cdn-icons-png.flaticon.com/128/1999/1999625.png',
    'https://cdn-icons-png.flaticon.com/128/4140/4140047.png',
    'https://cdn-icons-png.flaticon.com/128/147/147144.png',
    'https://cdn-icons-png.flaticon.com/128/236/236831.png',
    'https://cdn-icons-png.flaticon.com/128/4322/4322991.png',
    'https://cdn-icons-png.flaticon.com/128/4333/4333609.png',
    'https://cdn-icons-png.flaticon.com/128/1154/1154448.png',
    'https://cdn-icons-png.flaticon.com/128/16683/16683419.png',
    'https://cdn-icons-png.flaticon.com/128/1999/1999054.png',
    "https://cdn-icons-png.flaticon.com/128/924/924915.png",
    "https://cdn-icons-png.flaticon.com/128/3940/3940403.png",
    'https://cdn-icons-png.flaticon.com/128/706/706830.png',
  ];

  void signUp(
    BuildContext context,
  ) async {
    AuthController controller = AuthController();
    print(
        'in sign up of page function ${_nameController.text.trim() + _passwordController.text.trim()}');
    await controller.signUp(context, _nameController.text.trim(),
        _passwordController.text.trim(), selectedAvatar);
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Your Avatar",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                itemCount: avatarOptions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = avatarOptions[index];
                      });
                      Navigator.pop(context); // Close modal
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(avatarOptions[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(selectedAvatar),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showAvatarSelection,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username (please keep it unqiue)",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                child: TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: "Enter your username",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "Enter your password",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAccepted = value!;
                        });
                      },
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "I accept that losing the username would mean losing the account.",
                        style: GoogleFonts.poppins(
                          color: Pallete().buttonColor,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Sign Up Button
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonAuthBtn(
                  onTap: () {
                    // onTap: () {
                    print('touched');
                    signUp(context);
                    // },
                  },
                  text: 'Sign up'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.28),
              GestureDetector(
                onTap: () {
                  // Navigate to Login Screen (Replace with actual navigation)
                  moveScreen(context, LogInPage(), isPushReplacement: true);
                },
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: GoogleFonts.poppins(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Log in",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

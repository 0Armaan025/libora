import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/common/common_auth_btn.dart';
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/views/auth/sign_up_page.dart';
import 'package:libora/utils/utils.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isObscure = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isAccepted = false;

  void logIn(BuildContext context) {
    // Implement login functionality here
    AuthController _controller = AuthController();
    _controller.logIn(
        context, _nameController.text.trim(), _passwordController.text.trim());
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
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "Log In",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 35,
                  ),
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username",
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
              const SizedBox(
                height: 20,
              ),
              CommonAuthBtn(
                  onTap: () {
                    logIn(context);
                  },
                  text: 'Log In'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.48),
              GestureDetector(
                onTap: () {
                  // Navigate to Login Screen (Replace with actual navigation)
                  moveScreen(context, SignUpPage(), isPushReplacement: true);
                },
                child: Text.rich(
                  TextSpan(
                    text: "New to the app? ",
                    style: GoogleFonts.poppins(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign up",
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

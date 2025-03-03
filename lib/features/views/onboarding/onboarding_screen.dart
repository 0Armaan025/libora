import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/views/auth/sign_up_page.dart';
import 'package:libora/features/views/home/home_page.dart';
import 'package:libora/features/views/onboarding/onboarding_content_page.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // first check if user is logged in or not

    checkUserAuthStatus();
  }

  checkUserAuthStatus() {
    checkAuthStatus();
  }

  checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('name');
    print(
      "the user name is ${name}",
    );
    final isLoggedIn = prefs.getString('status');

    if (isLoggedIn == "logged_in") {
      print("the status is = ${isLoggedIn!}");

      moveScreen(context, HomePage(), isPushReplacement: true);
    } else {
      moveScreen(context, SignUpPage(), isPushReplacement: true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (pageIndex) {
              setState(() {
                currentPage = pageIndex;
              });
            },
            children: [
              const OnboardingContentPage(
                  imagePath: "assets/images/logo.png",
                  title: "Welcome to Libora! :)",
                  description:
                      "It's basically a virtual library, that does more than just providing books! :D"),
              const OnboardingContentPage(
                  imagePath: "assets/images/library_image.jpg",
                  title: "Books from libgen :P",
                  description:
                      "It works as a wrapper of libgen (better than librariumm) and uses nodejs instead of python which makes it way faster..."),
              const OnboardingContentPage(
                  imagePath: "assets/images/thank-you-2.gif",
                  title: "At the end,",
                  description:
                      "Thanks a lot for downloading it! Hope you enjoy using it! :D"),
            ],
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: InkWell(
              onTap: () {
                if (currentPage < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                } else {
                  moveScreen(context, SignUpPage(), isPushReplacement: true);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12).copyWith(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: Pallete().buttonColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentPage < 2 ? 'Next' : 'Get Started',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

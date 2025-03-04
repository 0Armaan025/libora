import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/repositories/auth_repository.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String _username = '';
  String _imageUrl = '';
  List<String> _followers = [];
  List<String> _following = [];
  List<String> _booksRead = [];
  bool _isCurrentUser = false;
  bool _isLoading = true;
  bool _weFollowing = false;

  late TextEditingController _usernameController;
  bool _isEditingUsername = false;

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchUserData();
  }

  void _initializeAnimations() {
    _usernameController = TextEditingController(text: widget.username);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.purple[700],
      end: Colors.blue[700],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUsername = prefs.getString('name');
      _isCurrentUser = currentUsername.toString().trim() ==
          widget.username.toString().trim();

      final authController = AuthController();
      final userData =
          await authController.getUserDetails(context, widget.username);

      setState(() {
        // showSnackBar(context, userData?['profileImage'] ?? 'bye');
        _username = userData?['name'] ?? widget.username;
        _imageUrl = userData?['user']['profileImage'] ??
            'https://cdn-icons-png.flaticon.com/128/1999/1999625.png';
        _followers = List<String>.from(userData?['user']['followers'] ?? []);
        _following = List<String>.from(userData?['user']['following'] ?? []);
        _booksRead = List<String>.from(userData?['user']['booksRead'] ?? []);
        _weFollowing = _followers.contains(currentUsername);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to load user data', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    try {
      final result = await AuthRepository().followUser(context, _username);
      if (result) {
        setState(() {
          _weFollowing = !_weFollowing;
          if (_weFollowing) {
            _followers.add(_username);
          } else {
            _followers.remove(_username);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update follow status',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _isDevUser => _username == "0Armaan025";

  @override
  Widget build(BuildContext context) {
    final Pallete palette = Pallete();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: palette.bgColor,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      backgroundColor: palette.bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileHeader(palette),
              const SizedBox(height: 20),
              _buildBooksReadSection(palette),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Pallete palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileImage(),
          const SizedBox(height: 20),
          _buildUsernameSection(),
          const SizedBox(height: 24),
          _buildFollowersSection(),
          const SizedBox(height: 24),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return _isDevUser
        ? AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _colorAnimation.value ?? Colors.black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_colorAnimation.value ?? Colors.black)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_imageUrl),
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_imageUrl),
            ),
          );
  }

  Widget _buildUsernameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isEditingUsername)
          _buildUsernameEditField()
        else
          _buildUsernameDisplay(),
      ],
    );
  }

  Widget _buildUsernameEditField() {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _usernameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.check, color: Colors.black),
          onPressed: () {
            setState(() {
              _username = _usernameController.text;
              _isEditingUsername = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildUsernameDisplay() {
    return Row(
      children: [
        GestureDetector(
          onTap: _isCurrentUser
              ? () => setState(() => _isEditingUsername = true)
              : null,
          child: Text(
            _username,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_isCurrentUser)
          IconButton(
              icon: Icon(Icons.edit, size: 18, color: Colors.black),
              onPressed: () {
                showSnackBar(context,
                    "sorry! this feature is not available yet im seeking some response first :(");
                setState(() {
                  _isEditingUsername = true;
                });
              }),
        if (_isDevUser) _buildDevBadge(),
      ],
    );
  }

  Widget _buildDevBadge() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (_colorAnimation.value ?? Colors.black).withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            "DEV",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem("${_followers.length}", "Followers"),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 24),
          ),
          _buildStatItem("${_following.length}", "Following"),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return _isCurrentUser
        ? ElevatedButton.icon(
            onPressed: () {
              showSnackBar(context,
                  "sorry! this feature is not available yet im seeking some response first :(");
              _showChangeNameDialog();
            },
            icon: const Icon(Icons.edit),
            label: Text(
              "Edit Profile",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              minimumSize: const Size(250, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: _toggleFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              minimumSize: const Size(250, 50),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _weFollowing ? "UnFollow" : "Follow",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showChangeNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Username',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Enter new username',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          style: GoogleFonts.poppins(),
          maxLength: 20, // Limit username length
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[800]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate username
              final newUsername = _usernameController.text.trim();
              if (newUsername.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Username cannot be empty',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                // // Call auth controller to update username
                // final authController = AuthController();
                // final success =
                //     await authController.updateUsername(context, newUsername);

                // if (success) {
                //   // Update local state
                //   setState(() {
                //     _username = newUsername;
                //     _isEditingUsername = false;
                //   });

                //   // Close dialog
                //   Navigator.pop(context);

                //   // Show success message
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         'Username updated successfully!',
                //         style: GoogleFonts.poppins(),
                //       ),
                //       backgroundColor: Colors.green,
                //     ),
                //   );
                // } else {
                //   // Handle update failure
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         'Failed to update username',
                //         style: GoogleFonts.poppins(),
                //       ),
                //       backgroundColor: Colors.red,
                //     ),
                //   );
                // }
              } catch (e) {
                // Handle any errors during username update
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'An error occurred: ${e.toString()}',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksReadSection(Pallete palette) {
    // Define a list of gradient colors for the books
    final List<List<Color>> bookGradients = [
      [const Color(0xFF6448FE), const Color(0xFF5FC6FF)],
      [const Color(0xFFFE6197), const Color(0xFFFFB463)],
      [const Color(0xFF61A3FE), const Color(0xFF63FFD5)],
      [const Color(0xFFFFA738), const Color(0xFFFFE130)],
      [const Color(0xFFFF5DCD), const Color(0xFF8484FF)],
      [Colors.black, Colors.black.withOpacity(0.7)],
      [const Color(0xFF0396FF), const Color(0xFFABDCFF)],
      [const Color(0xFF3C8CE7), const Color(0xFF00EAFF)],
      [const Color(0xFF696EFF), const Color(0xFFF8ACFF)],
      [const Color(0xFF14F195), const Color(0xFF7CFF6B)],
    ];

    // Apply special animation for dev user's books
    if (_isDevUser) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      (_colorAnimation.value ?? Colors.purple).withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Books Read",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _colorAnimation.value?.withOpacity(0.2) ??
                            Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Achievement",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _colorAnimation.value ?? Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildBooksReadIllustration(
                    _booksRead.length, bookGradients, palette),
              ],
            ),
          );
        },
      );
    } else {
      // Regular non-animated version for normal users
      return Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Books Read",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Achievement",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildBooksReadIllustration(
                _booksRead.length, bookGradients, palette),
          ],
        ),
      );
    }
  }

  Widget _buildBooksReadIllustration(
      int booksCount, List<List<Color>> gradients, Pallete palette) {
    // Create a visual representation of books read with special effects for dev user
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxBooks = 10;
              final displayedBooks =
                  booksCount > maxBooks ? maxBooks : booksCount;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    displayedBooks,
                    (index) => _isDevUser
                        ? AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              // Calculate a staggered effect for each book
                              final staggeredOffset =
                                  (index / maxBooks) * 2 * math.pi;
                              final sinValue = math.sin(
                                  _animationController.value * math.pi * 2 +
                                      staggeredOffset);
                              final heightFactor = 1.0 + (sinValue * 0.2);

                              return Transform.translate(
                                offset: Offset(0, sinValue * 5),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width:
                                      (constraints.maxWidth - (maxBooks * 8)) /
                                          maxBooks,
                                  height: 120 * heightFactor,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          gradients[index % gradients.length],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            gradients[index % gradients.length]
                                                    [0]
                                                .withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(2, 3),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Book spine details (small white lines)
                                      Positioned(
                                        left: 3,
                                        top: 15,
                                        child: Container(
                                          width: 2,
                                          height: 20,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      Positioned(
                                        left: 3,
                                        bottom: 15,
                                        child: Container(
                                          width: 2,
                                          height: 20,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: (constraints.maxWidth - (maxBooks * 8)) /
                                maxBooks,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradients[index % gradients.length],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: gradients[index % gradients.length][0]
                                      .withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Book spine details (small white lines)
                                Positioned(
                                  left: 3,
                                  top: 15,
                                  child: Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Positioned(
                                  left: 3,
                                  bottom: 15,
                                  child: Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _isDevUser
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _colorAnimation.value ?? Colors.black,
                          Colors.purple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: (_colorAnimation.value ?? Colors.black)
                              .withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_stories,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "$booksCount Books Read",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "$booksCount Books Read",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/models/User.dart';
import 'package:libora/features/views/profile/profile_view.dart';
import 'package:libora/utils/theme/Pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSearchView extends StatefulWidget {
  const UserSearchView({super.key});

  @override
  State<UserSearchView> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends State<UserSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  String _searchQuery = "";
  bool _isLoading = false;

  // Track followed users
  Set<String> followedUsers = {};

  // List to store API results
  List<UserModel> _users = [];

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _users = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://libora-api.onrender.com/api/user/search-users?query=$query');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (!data.containsKey('users')) {
          if (mounted) {
            showSnackBar(context, "Invalid response: No 'users' key found.");
          }
          setState(() {
            _users = [];
            _isLoading = false;
          });
          return;
        }

        List users = data['users'];
        print('Extracted Users: $users');
        print('Users Length: ${users.length}');

        if (users.isEmpty) {
          if (mounted) showSnackBar(context, "No users found.");
          setState(() {
            _users = [];
            _isLoading = false;
          });
          return;
        }

        List<UserModel> usersList = [];
        for (var user in users) {
          usersList.add(UserModel(
            pass: user['password'],
            booksRead: List<String>.from(user['booksRead'] ?? []), // ✅ Fixed
            createdAt: user['createdAt'],
            following: List<String>.from(user['following'] ?? []), // ✅ Fixed
            name: user['name'],
            profileImage: user['profileImage'],
            followers: List<String>.from(user['followers'] ?? []), // ✅ Fixed
          ));
        }

        setState(() {
          _users = usersList;
          _isLoading = false;
        });

        if (mounted) showSnackBar(context, "Found ${usersList.length} users.");
      } else {
        if (mounted) showSnackBar(context, "Error: ${response.body}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        showSnackBar(context, 'Error occurred :(, please contact Armaan!');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  // Function to handle following a user
  Future<void> followUser(String username) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final currentUserName = prefs.getString("name");

      if (currentUserName == null) {
        showSnackBar(context, "You're not logged in.");
        return;
      }

      // Optimized follow/unfollow logic
      final url =
          Uri.parse('https://libora-api.onrender.com/api/user/update-user');

      // Get current user data to check current following status
      final currentUserData =
          await AuthController().getUserDetails(context, currentUserName);
      final targetUserData =
          await AuthController().getUserDetails(context, username);

      if (currentUserData == null || targetUserData == null) {
        showSnackBar(context, "Error fetching user data.");
        return;
      }

      List<dynamic> currentUserFollowing =
          List<dynamic>.from(currentUserData['following'] ?? []);
      List<dynamic> targetUserFollowers =
          List<dynamic>.from(targetUserData['followers'] ?? []);

      bool isCurrentlyFollowing = currentUserFollowing.contains(username);

      // Prepare updates
      Map<String, dynamic> currentUserUpdates = {};
      Map<String, dynamic> targetUserUpdates = {};

      if (isCurrentlyFollowing) {
        // Unfollow logic
        currentUserFollowing.remove(username);
        targetUserFollowers.remove(currentUserName);
      } else {
        // Follow logic
        currentUserFollowing.add(username);
        targetUserFollowers.add(currentUserName);
      }

      currentUserUpdates['following'] = currentUserFollowing;
      targetUserUpdates['followers'] = targetUserFollowers;

      // Update current user's following
      final currentUserUpdateResponse = await http.patch(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"name": currentUserName, "updates": currentUserUpdates}));

      // Update target user's followers
      final targetUserUpdateResponse = await http.patch(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": username, "updates": targetUserUpdates}));

      // Check if both updates were successful
      if (currentUserUpdateResponse.statusCode == 200 &&
          targetUserUpdateResponse.statusCode == 200) {
        setState(() {
          if (followedUsers.contains(username)) {
            followedUsers.remove(username);
          } else {
            followedUsers.add(username);
          }
        });

        showSnackBar(
            context,
            isCurrentlyFollowing
                ? "Unfollowed $username"
                : "Followed $username");
      } else {
        showSnackBar(context, "Failed to update follow status.");
      }
    } catch (e) {
      print('Follow User Error: $e');
      showSnackBar(context, 'Error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the build method remains the same as in the previous implementation
    return Scaffold(
      backgroundColor: Pallete().bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Discover People",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Search Bar with Animation (previous implementation)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.symmetric(horizontal: _isSearching ? 16 : 12),
              height: 56,
              decoration: BoxDecoration(
                color: _isSearching ? Colors.grey[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSearching
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
                border: Border.all(
                  color: _isSearching
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: _isSearching ? Colors.blue : Colors.grey[700],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: "Search for users...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      onSubmitted: (value) {
                        // Trigger search when user presses enter
                        searchUsers(value);
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _users = [];
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                    ),
                  // Search button
                  GestureDetector(
                    onTap: () {
                      searchUsers(_searchController.text);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                _isLoading
                    ? "Searching..."
                    : "${_users.length} ${_users.length == 1 ? 'user' : 'users'} found",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),

            // Users List
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _users.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return _buildUserCard(user, context);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    final bool isFollowing = followedUsers.contains(user.name);
    final String avatarUrl =
        user.profileImage ?? "https://randomuser.me/api/portraits/lego/1.jpg";

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to user profile
            moveScreen(context, ProfilePage(username: user.name));
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey[700]!),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[700],
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 6),
                          if (user.name == "0Armaan025")
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: _buildFollowInfo(
                            formatFollowers(user.followers.length),
                            "followers"),
                      ),
                    ],
                  ),
                ),

                // Follow Button
                TextButton(
                  onPressed: () {
                    // Call the followUser function and pass the user ID
                    followUser(user.name);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isFollowing ? Colors.grey[200] : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size(0, 0),
                  ),
                  child: Text(
                    isFollowing ? "Following" : "Follow",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isFollowing ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowInfo(String count, String label) {
    return Row(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? "Search for users" : "No users found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? "Type a name to find users"
                : "Try a different search term",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            "Searching for users...",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

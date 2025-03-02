import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:libora/utils/theme/Pallete.dart';

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

  // Sample list of users
  final List<Map<String, dynamic>> users = [
    {
      "username": "emma_design",
      "name": "Emma Johnson",
      "followers": 12542,
      "following": 345,
      "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      "isVerified": true,
    },
    {
      "username": "alex_photography",
      "name": "Alex Chen",
      "followers": 8976,
      "following": 512,
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "isVerified": false,
    },
    {
      "username": "sarah_travels",
      "name": "Sarah Wilson",
      "followers": 24681,
      "following": 731,
      "avatar": "https://randomuser.me/api/portraits/women/68.jpg",
      "isVerified": true,
    },
    {
      "username": "mike_fitness",
      "name": "Mike Taylor",
      "followers": 5823,
      "following": 294,
      "avatar": "https://randomuser.me/api/portraits/men/75.jpg",
      "isVerified": false,
    },
    {
      "username": "jess_art",
      "name": "Jessica Reynolds",
      "followers": 15937,
      "following": 420,
      "avatar": "https://randomuser.me/api/portraits/women/90.jpg",
      "isVerified": true,
    },
    {
      "username": "david_music",
      "name": "David Parker",
      "followers": 3682,
      "following": 186,
      "avatar": "https://randomuser.me/api/portraits/men/41.jpg",
      "isVerified": false,
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    if (_searchQuery.isEmpty) {
      return users;
    }

    return users.where((user) {
      return user["username"]
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user["name"].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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

  @override
  Widget build(BuildContext context) {
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

            // Search Bar with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.symmetric(horizontal: _isSearching ? 16 : 12),
              height: 56,
              decoration: BoxDecoration(
                color: _isSearching ? Colors.grey[900] : Colors.grey[850],
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSearching
                    ? [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
                border: Border.all(
                  color: _isSearching
                      ? Colors.blueAccent.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: _isSearching ? Colors.blueAccent : Colors.white70,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: "Search for users...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),

            // Filter Chips

            // Results count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                "${filteredUsers.length} ${filteredUsers.length == 1 ? 'user' : 'users'} found",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),

            // Users List
            Expanded(
              child: filteredUsers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _buildUserCard(user, context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.grey[850],
        selectedColor: Colors.blueAccent.withOpacity(0.3),
        checkmarkColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 1,
          ),
        ),
        onSelected: (bool selected) {
          // Handle filter selection
        },
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to user profile
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Viewing ${user['username']}'s profile"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: user["avatar"],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white70),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (user["isVerified"])
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                            user["username"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          if (user["isVerified"])
                            Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                              size: 16,
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        user["name"],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          _buildFollowInfo(
                              formatFollowers(user["followers"]), "followers"),
                          Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              shape: BoxShape.circle,
                            ),
                          ),
                          _buildFollowInfo(
                              user["following"].toString(), "following"),
                        ],
                      ),
                    ],
                  ),
                ),

                // Follow Button
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Following ${user['username']}"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
                    "Follow",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
            color: Colors.white,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white60,
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
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            "No users found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try a different search term",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}

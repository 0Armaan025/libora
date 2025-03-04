import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:libora/common/space_list.dart';
import 'package:libora/features/models/Space.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:libora/features/views/create_space/create_space_view.dart';
import 'package:libora/features/views/join_space/join_space_view.dart';
import 'package:libora/utils/utils.dart';

class SpacesView extends StatefulWidget {
  const SpacesView({super.key});

  @override
  State createState() => _SpacesViewState();
}

class _SpacesViewState extends State<SpacesView> {
  // Sample data for spaces
  List<dynamic> spaces = [];
  List<String> users = [];
  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpaceData();
  }

  getSpaceData() {
    getData();
  }

  getData() async {
    ApiService service = ApiService();
    final data = await service.getActiveSpaces(context);
    setState(() {
      spaces = data;
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor("#2b2e32");
    final secondaryColor = HexColor("#3e7bfa");

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active Spaces",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
              child: Row(
                children: [
                  // Create Space Button
                  Expanded(
                    child: _buildActionButton(
                      label: "Create",
                      icon: Icons.add_circle_outline,
                      color: secondaryColor,
                      onTap: () {
                        moveScreen(context, CreateSpaceScreen());
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Join Space Button
                  Expanded(
                    child: _buildActionButton(
                      label: "Join",
                      icon: Icons.group_add_outlined,
                      color: primaryColor,
                      onTap: () {
                        moveScreen(context, JoinSpaceScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Fixed-height list container - this prevents unbounded height errors
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Text(
                      "Spaces right now",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Expanded ListView to fill remaining space
                    Expanded(
                      child: spaces.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              // Key physics settings to ensure proper scrolling
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: spaces.length,
                              itemBuilder: (context, index) {
                                final space = spaces[index];
                                return SpaceList(
                                  spaceName: space.name,

                                  // profilePictures: List<String>.from(
                                  //   space["profiles"],
                                  // ),
                                  people: space.people,
                                  // lastActive: space["lastActive"],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No Active Spaces",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create or join a space to get started",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceCard(
    BuildContext context, {
    required String spaceName,
    required int members,
    required List<String> profilePictures,
    required String lastActive,
  }) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to space details
            debugPrint("Tapped on $spaceName");
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Space name and activity indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          spaceName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor("#e8f1ff"),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lastActive,
                          style: GoogleFonts.poppins(
                            color: HexColor("#3e7bfa"),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Members count and profile pictures
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$members members",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 32,
                        child: Stack(
                          children: List.generate(
                                profilePictures.length > 3
                                    ? 3
                                    : profilePictures.length,
                                (index) => Positioned(
                                  left: index * 20.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: NetworkImage(
                                        profilePictures[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ).toList() +
                              (profilePictures.length > 3
                                  ? [
                                      Positioned(
                                        left: 3 * 20.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                HexColor("#3e7bfa"),
                                            child: Text(
                                              "+${profilePictures.length - 3}",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  : []),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

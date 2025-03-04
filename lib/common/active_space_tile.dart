import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/common/space_list.dart';
import 'package:libora/features/repositories/space_repository.dart';

class ActiveSpacesTile extends StatefulWidget {
  const ActiveSpacesTile({super.key});

  @override
  State<ActiveSpacesTile> createState() => _ActiveSpacesTileState();
}

class _ActiveSpacesTileState extends State<ActiveSpacesTile> {
  List<dynamic> spaces = [];

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
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1,
      height: size.height * 0.25,
      margin: const EdgeInsets.symmetric(horizontal: 12)
          .copyWith(left: 0, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 8),
            child: Text(
              "Active spaces",
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SizedBox(
              height: size.height * 0.15,
              child: spaces.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      // Key physics settings to ensure proper scrolling
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: spaces.length >= 3 ? 3 : spaces.length,
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
          ),
        ],
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.group_outlined,
          size: 30,
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

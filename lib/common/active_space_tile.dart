import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/common/space_list.dart';

class ActiveSpacesTile extends StatefulWidget {
  const ActiveSpacesTile({super.key});

  @override
  State<ActiveSpacesTile> createState() => _ActiveSpacesTileState();
}

class _ActiveSpacesTileState extends State<ActiveSpacesTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1,
      height: size.height * 0.2,
      margin: const EdgeInsets.symmetric(horizontal: 12),
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
            child: SpaceList(
              spaceName: 'My Space',
              profilePictures: [
                'https://cdn-icons-png.flaticon.com/128/1999/1999625.png'
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/views/msg_view/msg_view.dart';
import 'package:libora/utils/utils.dart';

class BookCommunityScreen extends StatefulWidget {
  const BookCommunityScreen({super.key});

  @override
  State<BookCommunityScreen> createState() => _BookCommunityScreenState();
}

class _BookCommunityScreenState extends State<BookCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Libora",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "Community",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                "Read",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Community Grid
          _buildCommunityTab(),
          // Tab 2: Book Search and Read
          _buildReadTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to messaging screen
          moveScreen(context, GroupChatScreen(spaceName: "active sapce"));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildCommunityTab() {
    // Sample data for community members
    final List<Map<String, dynamic>> communityMembers = [
      {
        "name": "Alice",
        "book": "The Great Gatsby",
        "image": "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
      },
      {
        "name": "Bob",
        "book": "1984",
        "image": "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
      },
      {
        "name": "Charlie",
        "book": "To Kill a Mockingbird",
        "image": "https://cdn-icons-png.flaticon.com/128/4333/4333609.png",
      },
      {
        "name": "Diana",
        "book": "Pride and Prejudice",
        "image": "https://cdn-icons-png.flaticon.com/128/4333/4333607.png",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: communityMembers.length,
        itemBuilder: (context, index) {
          final member = communityMembers[index];
          return _buildCommunityCard(member);
        },
      ),
    );
  }

  Widget _buildCommunityCard(Map<String, dynamic> member) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(member["image"]),
              ),
              const SizedBox(height: 4),
              Text(
                member["name"],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Reading: ${member["book"]}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search for a book...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 32),
          // Placeholder for book content
          Expanded(
            child: Center(
              child: Text(
                "Select a book to read",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:libora/features/views/msg_view/msg_view.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCommunityScreen extends StatefulWidget {
  final String code;
  const BookCommunityScreen({super.key, required this.code});

  @override
  State<BookCommunityScreen> createState() => _BookCommunityScreenState();
}

class _BookCommunityScreenState extends State<BookCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

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

  // Sample data for books
  final List<Map<String, dynamic>> books = [
    {
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389081.png",
      "rating": 4.5,
    },
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389022.png",
      "rating": 4.8,
    },
    {
      "title": "1984",
      "author": "George Orwell",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389017.png",
      "rating": 4.6,
    },
    {
      "title": "Pride and Prejudice",
      "author": "Jane Austen",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389019.png",
      "rating": 4.7,
    },
    {
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389009.png",
      "rating": 4.9,
    },
    {
      "title": "The Catcher in the Rye",
      "author": "J.D. Salinger",
      "cover": "https://cdn-icons-png.flaticon.com/512/3389/3389035.png",
      "rating": 4.3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    getPersonouttaHere();

    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
    getPersonouttaHere();
  }

  @override
  void deactivate() {
    getPersonouttaHere();
    // TODO: implement deactivate
    super.deactivate();
    // now I want to get the person out of any joined spaces
    getPersonouttaHere();
  }

  getPersonouttaHere() {
    getMeOut();
  }

  getMeOut() async {
    ApiService service = ApiService();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = prefs.getString("name");
    await service.leaveSpace(name!, widget.code);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  // Function to handle member selection
  void onMemberSelected(Map<String, dynamic> member) {
    // Call your function here
    print('Selected member: ${member["name"]}');

    // Show a snackbar for demonstration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${member["name"]}\'s profile'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Add your implementation here
    // For example: navigateToMemberProfile(member);
  }

  // Function to handle book selection
  void onBookSelected(Map<String, dynamic> book) {
    // Show a snackbar for demonstration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${book["title"]}"'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Add your implementation here
    // For example: navigateToBookReader(book);
  }

  // Function to handle book search
  void onBookSearch(String query) {
    // Call your function here
    print('Searching for book: $query');

    // Add your implementation here
    // For example: fetchBooks(query);
  }

  List<Map<String, dynamic>> get filteredMembers {
    if (_searchQuery.isEmpty) {
      return communityMembers;
    }
    return communityMembers.where((member) {
      return member["name"]
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          member["book"].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredBooks {
    if (_searchQuery.isEmpty) {
      return books;
    }
    return books.where((book) {
      return book["title"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book["author"].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Libora",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue[800],
          unselectedLabelColor: Colors.grey[600],
          indicatorSize: TabBarIndicatorSize.label,
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
          // Tab 1: Community Grid with Search
          _buildCommunityTab(),
          // Tab 2: Book Search and Read
          _buildReadTab(),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to messaging screen
            moveScreen(context, GroupChatScreen(spaceName: "active sapce"));
          },
          backgroundColor: Colors.blue,
          elevation: 3,
          child: const Icon(Icons.message, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCommunityTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Adjusts to content size
            children: [
              Text(
                "Space code: ${widget.code}",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 24),
              ),
              SizedBox(width: 8), // Adds some space between text and icon
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: "456"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Copied to clipboard!")),
                  );
                },
                child: Icon(Icons.copy, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Results count
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${filteredMembers.length} ${filteredMembers.length == 1 ? 'result' : 'results'} found",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

        // Grid of community members
        Expanded(
          child: filteredMembers.isEmpty
              ? _buildEmptyState()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      return _buildCommunityCard(member);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCommunityCard(Map<String, dynamic> member) {
    return Hero(
      tag: 'member-${member["name"]}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onMemberSelected(member),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(member["image"]),
                ),
                const SizedBox(height: 12),
                Text(
                  member["name"],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Reading: ${member["book"]}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isSearchFocused ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isSearchFocused
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
              border: Border.all(
                color: _isSearchFocused
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onSubmitted: onBookSearch,
              decoration: InputDecoration(
                hintText: "Search for a book...",
                prefixIcon: Icon(
                  Icons.search,
                  color: _isSearchFocused ? Colors.blue : Colors.grey[600],
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header for book section
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
            child: Text(
              _searchQuery.isEmpty ? "Popular Books" : "Search Results",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // Book Grid
          Expanded(
            child: filteredBooks.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65, // Taller for book covers
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return _buildBookCard(book);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Hero(
      tag: 'book-${book["title"]}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onBookSelected(book),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Book cover
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    height: 100,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(book["cover"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Book title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    book["title"],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 4),

                // Author
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    book["author"],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Rating
              ],
            ),
          ),
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
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try a different search term",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

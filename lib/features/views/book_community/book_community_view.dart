import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/controllers/book_controller.dart';
import 'package:libora/features/models/Book.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:libora/features/views/book_info/book_info_view.dart';
import 'package:libora/features/views/msg_view/msg_view.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class BookCommunityScreen extends StatefulWidget {
  final String code;
  const BookCommunityScreen({super.key, required this.code});

  @override
  State<BookCommunityScreen> createState() => _BookCommunityScreenState();
}

class _BookCommunityScreenState extends State<BookCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Separate controllers for each tab
  final TextEditingController _communitySearchController =
      TextEditingController();
  final TextEditingController _bookSearchController = TextEditingController();

  // Separate focus nodes for each tab
  final FocusNode _communitySearchFocusNode = FocusNode();
  final FocusNode _bookSearchFocusNode = FocusNode();

  // Separate search queries for each tab
  String _communitySearchQuery = "";
  String _bookSearchQuery = "";

  // Track which search field is focused
  bool _isCommunitySearchFocused = false;
  bool _isBookSearchFocused = false;

  // List to store community members with their details
  List<Map<String, dynamic>> communityMembers = [];
  bool isLoading = true;

  List<BookModel> searchedBooks = [];

  // Flag to show book detail screen
  bool _showBookDetail = false;

  // Selected book information
  String? _selectedBookTitle;
  String? _selectedBookAuthor;
  String? _selectedBookImageUrl;
  String? _selectedBookDescription;

  // Non-romantic emojis for reading status
  final List<String> readingEmojis = [
    '📚',
    '📖',
    '🔍',
    '🧠',
    '🎓',
    '💡',
    '🌟',
    '🌈',
    '🌻',
    '🍀',
    '🌴',
    '🌋',
    '🏔️',
    '🏕️',
    '🚀',
    '⭐',
    '✨',
    '🔭',
    '🎯',
    '🧩',
    '🎲',
    '🎮',
    '🎸',
    '🎨',
    '🏆',
    '🥇',
    '🏅',
    '🏄',
    '🏃',
    '🧗',
  ];

  // Sample data for books (keeping this unchanged)
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

    // Set up listeners for community tab
    _communitySearchController.addListener(_onCommunitySearchChanged);
    _communitySearchFocusNode.addListener(_onCommunitySearchFocusChanged);

    // Set up listeners for book tab
    _bookSearchController.addListener(_onBookSearchChanged);
    _bookSearchFocusNode.addListener(_onBookSearchFocusChanged);

    getPeople();
  }

  // Get random emoji for reading status
  String getRandomEmoji() {
    final random = Random();
    return readingEmojis[random.nextInt(readingEmojis.length)];
  }

  getPeople() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getPeopleHere();
    } catch (e) {
      print("Error getting people: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  getPeopleHere() async {
    ApiService service = ApiService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");

    final peopleList = await service.getPeople(widget.code);
    print("People are $peopleList");

    // Clear the current list
    communityMembers.clear();

    // Get details for each person and add to communityMembers
    if (peopleList is List) {
      for (String personName in peopleList) {
        try {
          final userDetails = await getUserDetails(context, personName);
          if (userDetails != null) {
            // Add user with details to our list
            communityMembers.add({
              "name": personName,
              "emoji": getRandomEmoji(), // Random emoji for reading status
              "image": userDetails["profileImage"] ??
                  "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
            });
          }
        } catch (e) {
          print("Error getting details for $personName: $e");
          // Add with default values if there's an error
          communityMembers.add({
            "name": personName,
            "emoji": getRandomEmoji(),
            "image": "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
          });
        }
      }

      // Update the UI
      setState(() {});
    }
  }

  // Get user details - Modified to return user data
  Future<Map<String, dynamic>?> getUserDetails(
      BuildContext context, String name) async {
    AuthController controller = AuthController();
    try {
      final user = await controller.getUserDetails(context, name);
      return user;
    } catch (e) {
      print("Error fetching user details for $name: $e");
      return null;
    }
  }

  @override
  void dispose() {
    getPersonouttaHere();
    _tabController.dispose();

    // Dispose controllers and focus nodes for both tabs
    _communitySearchController.dispose();
    _bookSearchController.dispose();
    _communitySearchFocusNode.dispose();
    _bookSearchFocusNode.dispose();

    super.dispose();
  }

  void searchBooks(BuildContext context) async {
    final query = _bookSearchController.text;
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a search term")),
      );
      return;
    }

    // Fetch books based on search query
    BookController controller = BookController();
    searchedBooks = await controller.fetchBooks(context, query);
    setState(() {
      // Reset book detail view when performing a new search
      _showBookDetail = false;
    });
  }

  @override
  void deactivate() {
    getPersonouttaHere();
    super.deactivate();
  }

  getPersonouttaHere() {
    getMeOut();
  }

  getMeOut() async {
    ApiService service = ApiService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");
    if (name != null) {
      await service.leaveSpace(name, widget.code);
    }
  }

  // Updated search listeners for each tab
  void _onCommunitySearchChanged() {
    setState(() {
      _communitySearchQuery = _communitySearchController.text;
    });
  }

  void _onCommunitySearchFocusChanged() {
    setState(() {
      _isCommunitySearchFocused = _communitySearchFocusNode.hasFocus;
    });
  }

  void _onBookSearchChanged() {
    setState(() {
      _bookSearchQuery = _bookSearchController.text;
    });
  }

  void _onBookSearchFocusChanged() {
    setState(() {
      _isBookSearchFocused = _bookSearchFocusNode.hasFocus;
    });
  }

  // Function to handle member selection
  void onMemberSelected(Map<String, dynamic> member) {
    print('Selected member: ${member["name"]}');

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
  }

  // Modified to show book details in the read tab
  void onBookSelected(BookModel book) {
    // First switch to reading tab
    _tabController.animateTo(1);

    // Show a snackbar indicating the book is being opened
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${book.title}"'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Update the state to show book details within the tab
    setState(() {
      _showBookDetail = true;
      _selectedBookTitle = book.title;
      _selectedBookAuthor = book.author;
      _selectedBookDescription = "don't judge it yet ;)";
      _selectedBookImageUrl =
          "https://cdn-icons-png.flaticon.com/512/3389/3389081.png";
    });
  }

  // Function to go back to the book search view
  void _backToBookSearch() {
    setState(() {
      _showBookDetail = false;
    });
  }

  // Function to handle book search
  void onBookSearch(String query) async {
    searchBooks(context);
  }

  // Filtering community members based on community search query only
  List<Map<String, dynamic>> get filteredMembers {
    if (_communitySearchQuery.isEmpty) {
      return communityMembers;
    }
    return communityMembers.where((member) {
      return member["name"]
          .toLowerCase()
          .contains(_communitySearchQuery.toLowerCase());
    }).toList();
  }

  // Filtering books based on book search query only
  List<Map<String, dynamic>> get filteredBooks {
    if (_bookSearchQuery.isEmpty) {
      return books;
    }
    return books.where((book) {
      return book["title"]
              .toLowerCase()
              .contains(_bookSearchQuery.toLowerCase()) ||
          book["author"].toLowerCase().contains(_bookSearchQuery.toLowerCase());
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
          _showBookDetail ? _buildBookDetailScreen() : _buildReadTab(),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to messaging screen
            moveScreen(context,
                GroupChatScreen(spaceName: "active space", code: widget.code));
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
        // Space code with copy button
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Space code: ${widget.code}",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 24),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Copied to clipboard!")),
                  );
                },
                child: Icon(Icons.copy, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Add Community Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:
                  _isCommunitySearchFocused ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isCommunitySearchFocused
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
                color: _isCommunitySearchFocused
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _communitySearchController,
              focusNode: _communitySearchFocusNode,
              decoration: InputDecoration(
                hintText: "Search community members...",
                prefixIcon: Icon(
                  Icons.search,
                  color: _isCommunitySearchFocused
                      ? Colors.blue
                      : Colors.grey[600],
                ),
                suffixIcon: _communitySearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _communitySearchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              ),
            ),
          ),
        ),

        // Results count when searching
        if (_communitySearchQuery.isNotEmpty)
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

        // Loading indicator or grid of members
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : filteredMembers.isEmpty
                  ? _buildEmptyState("No community members found",
                      "Try a different search term or invite more people")
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
                    "Reading right now ${member["emoji"]}",
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
          // Search Bar for Books Tab
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isBookSearchFocused ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isBookSearchFocused
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
                color: _isBookSearchFocused
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _bookSearchController,
              focusNode: _bookSearchFocusNode,
              onSubmitted: onBookSearch,
              decoration: InputDecoration(
                hintText: "Search for a book...",
                prefixIcon: Icon(
                  Icons.search,
                  color: _isBookSearchFocused ? Colors.blue : Colors.grey[600],
                ),
                suffixIcon: _bookSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _bookSearchController.clear();
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
          if (_bookSearchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
              child: Text(
                "Search Results",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

          // Book Grid
          Expanded(
            child: _bookSearchQuery.isEmpty
                ? _buildEmptySearchState() // Empty state when no search
                : searchedBooks.isEmpty
                    ? _buildEmptyState("No books found",
                        "Try a different search term") // Empty state for no results
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: searchedBooks.length,
                        itemBuilder: (context, index) {
                          final book = searchedBooks[index];
                          return _buildBookCard(book);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // New method to build the book detail screen within the tab
  Widget _buildBookDetailScreen() {
    return BookDetailScreen(
      bookName: _selectedBookTitle ?? "",
      authorName: _selectedBookAuthor ?? "",
      description: _selectedBookDescription ?? "",
      imageUrl: _selectedBookImageUrl ??
          "https://cdn-icons-png.flaticon.com/512/3389/3389081.png",
      // onBackPressed: _backToBookSearch, // Add back functionality
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Search for books",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter a book title or author name",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BookModel book) {
    return InkWell(
      onTap: () => onBookSelected(book),
      child: Hero(
        tag: 'book-${book.title}',
        child: Material(
          color: Colors.transparent,
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
                        image: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/3389/3389081.png"),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Fallback image in case of error
                          return;
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Book title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    book.title,
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
                    book.author,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
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
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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

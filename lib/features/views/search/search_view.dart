import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  // Sample list of books
  final List<Map<String, String>> books = [
    {
      "title": "The Alchemist",
      "author": "Paulo Coelho",
      "pages": "208",
      "cover":
          "https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg"
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "pages": "320",
      "cover":
          "https://images-na.ssl-images-amazon.com/images/I/81wgcld4wxL.jpg"
    },
    {
      "title": "1984",
      "author": "George Orwell",
      "pages": "328",
      "cover":
          "https://images-na.ssl-images-amazon.com/images/I/71kxa1-0AfL.jpg"
    },
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "pages": "281",
      "cover":
          "https://images-na.ssl-images-amazon.com/images/I/81OthjkJBuL.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f9f5ea"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for books...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Books List
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      color: Colors.grey[800],
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            book["cover"]!,
                            width: 50,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          book["title"]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          "by ${book["author"]} • ${book["pages"]} pages",
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.white70),
                        onTap: () {
                          // Handle book tap
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

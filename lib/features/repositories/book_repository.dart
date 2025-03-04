import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libora/features/controllers/auth_controller.dart';
import 'package:libora/features/models/Book.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookRepository {
  final String baseUrl =
      "https://5000-0armaan025-liboraapi-tiluu0ibikh.ws-us118.gitpod.io";

  Future<List<BookModel>> fetchBooks(BuildContext context, String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/scrape?name=$query"),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
      },
    );

    try {
      print("body of the response is: ${response.body}");
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body); // Parse as Map

      if (response.statusCode == 200) {
        if (!jsonResponse.containsKey('data') || jsonResponse['data'] == null) {
          throw Exception("Invalid response: 'data' field missing");
        }

        final List<dynamic> data = jsonResponse['data']; // Extract "data" list

        final filteredData = data.map((e) {
          final filtered =
              Map<String, dynamic>.from(e); // Create a new mutable copy
          filtered.remove('mirrors');
          filtered.remove('bookUrl');
          return filtered;
        }).toList();

        return filteredData.map((e) => BookModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load books");
      }
    } catch (e) {
      print('error is ${e.toString()}');
      throw Exception("Failed to parse books");
    }
  }

  Future<bool> addReadBook(BuildContext context, String bookName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get current user's name from SharedPreferences
    String? currentUserName = prefs.getString("name");

    if (currentUserName == null) {
      showSnackBar(context, "You're not logged in. Please log in first.");
      return false;
    }

    try {
      // Get the current user's data
      final currentUserData =
          await AuthController().getUserDetails(context, currentUserName);

      if (currentUserData == null) {
        showSnackBar(context, "Error fetching user data.");
        return false;
      }

      // Convert to List<String> to manipulate
      List<dynamic> currentReadBooks =
          List<dynamic>.from(currentUserData['readBooks'] ?? []);

      // Check if book is already in read books
      if (currentReadBooks.contains(bookName)) {
        return false;
      }

      // Add the book name
      currentReadBooks.add(bookName);

      // Prepare updates
      final userUpdates = {'readBooks': currentReadBooks};

      // Update user's read books
      final updateUrl =
          Uri.parse('https://libora-api.onrender.com/api/user/update-user');
      final updateResponse = await http.patch(updateUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": currentUserName, "updates": userUpdates}));

      // Check if update was successful
      if (updateResponse.statusCode == 200) {
        showSnackBar(context, "Book added to your read list!");
        return true;
      } else {
        showSnackBar(context, "Failed to add book to read list.");
        return false;
      }
    } catch (e) {
      print("Add Read Book Error: $e");
      showSnackBar(context, "An error occurred. Please try again.");
      return false;
    }
  }

  Future<File?> getStreamedBook(
      String mirrorUrl, String title, String format) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/api/scrape/download?mirrorUrl=$mirrorUrl&title=$title&format=$format"));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      final file = File(title);
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception("Failed to load book");
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libora/features/models/Book.dart';

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

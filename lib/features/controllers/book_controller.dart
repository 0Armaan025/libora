import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libora/features/models/Book.dart';
import 'package:libora/features/repositories/book_repository.dart';

class BookController {
  final BookRepository _bookRepository = BookRepository();

  Future<List<BookModel>> fetchBooks(BuildContext context, String query) async {
    return await _bookRepository.fetchBooks(context, query);
  }

  Future<File?> getStreamedBook(
      String mirrorUrl, String title, String format) async {
    return await _bookRepository.getStreamedBook(mirrorUrl, title, format);
  }
}

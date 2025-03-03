// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookModel {
  final String title;
  final String author;
  final String publisher;
  final String year;
  final String language;
  final String fileSize;
  final String format;
  BookModel({
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.language,
    required this.fileSize,
    required this.format,
  });

  BookModel copyWith({
    String? title,
    String? author,
    String? publisher,
    String? year,
    String? language,
    String? fileSize,
    String? format,
  }) {
    return BookModel(
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      language: language ?? this.language,
      fileSize: fileSize ?? this.fileSize,
      format: format ?? this.format,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
      'language': language,
      'fileSize': fileSize,
      'format': format,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'] as String,
      author: map['author'] as String,
      publisher: map['publisher'] as String,
      year: map['year'] as String,
      language: map['language'] as String,
      fileSize: map['fileSize'] as String,
      format: map['format'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookModel(title: $title, author: $author, publisher: $publisher, year: $year, language: $language, fileSize: $fileSize, format: $format)';
  }

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.author == author &&
        other.publisher == publisher &&
        other.year == year &&
        other.language == language &&
        other.fileSize == fileSize &&
        other.format == format;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        publisher.hashCode ^
        year.hashCode ^
        language.hashCode ^
        fileSize.hashCode ^
        format.hashCode;
  }
}

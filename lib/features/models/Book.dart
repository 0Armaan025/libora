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
  final String libgenMirror;
  BookModel({
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.language,
    required this.fileSize,
    required this.format,
    required this.libgenMirror,
  });

  BookModel copyWith({
    String? title,
    String? author,
    String? publisher,
    String? year,
    String? language,
    String? fileSize,
    String? format,
    String? libgenMirror,
  }) {
    return BookModel(
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      language: language ?? this.language,
      fileSize: fileSize ?? this.fileSize,
      format: format ?? this.format,
      libgenMirror: libgenMirror ?? this.libgenMirror,
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
      'libgenMirror': libgenMirror,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      year: map['year'] ?? '',
      language: map['language'] ?? '',
      fileSize: map['fileSize'] ?? '',
      format: map['format'] ?? '',
      libgenMirror: map['libgenMirror'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(Map<String, dynamic> map) =>
      BookModel.fromMap(map);

  @override
  String toString() {
    return 'BookModel(title: $title, author: $author, publisher: $publisher, year: $year, language: $language, fileSize: $fileSize, format: $format, libgenMirror: $libgenMirror)';
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
        other.format == format &&
        other.libgenMirror == libgenMirror;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        publisher.hashCode ^
        year.hashCode ^
        language.hashCode ^
        fileSize.hashCode ^
        format.hashCode ^
        libgenMirror.hashCode;
  }
}

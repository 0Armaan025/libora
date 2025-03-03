// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String pass;
  final String profileImage;
  final String createdAt;
  final List<String> followers;
  final List<String> following;
  final List<String> booksRead;
  UserModel({
    required this.name,
    required this.pass,
    required this.profileImage,
    required this.createdAt,
    required this.followers,
    required this.following,
    required this.booksRead,
  });

  UserModel copyWith({
    String? name,
    String? pass,
    String? profileImage,
    String? createdAt,
    List<String>? followers,
    List<String>? following,
    List<String>? booksRead,
  }) {
    return UserModel(
      name: name ?? this.name,
      pass: pass ?? this.pass,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      booksRead: booksRead ?? this.booksRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'pass': pass,
      'profileImage': profileImage,
      'createdAt': createdAt,
      'followers': followers,
      'following': following,
      'booksRead': booksRead,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      pass: map['pass'] as String,
      profileImage: map['profileImage'] as String,
      createdAt: map['createdAt'] as String,
      followers: List<String>.from((map['followers'] ?? [])),
      following: List<String>.from((map['following'] ?? [])),
      booksRead: List<String>.from((map['booksRead'] ?? [])),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, pass: $pass, profileImage: $profileImage, createdAt: $createdAt, followers: $followers, following: $following, booksRead: $booksRead)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.pass == pass &&
        other.profileImage == profileImage &&
        other.createdAt == createdAt &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        listEquals(other.booksRead, booksRead);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pass.hashCode ^
        profileImage.hashCode ^
        createdAt.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        booksRead.hashCode;
  }
}

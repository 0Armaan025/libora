import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libora/features/models/User.dart';
import 'package:libora/features/views/home/home_page.dart';
import 'package:libora/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> signUp(String name, String pass, BuildContext context,
      String profileImage) async {
    final url = Uri.parse('https://libora-api.onrender.com/api/user/register');

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"name": name, "pass": pass, "profileImage": profileImage}));
      print('in repository function');
      if (response.statusCode == 200) {
        print("code is 200");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", name);
        await prefs.setString("status", "logged_in");

        moveScreen(context, HomePage(), isPushReplacement: true);
      } else {
        print(response.body);
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred :(, please contact Armaan!');
    }
  }

  Future<void> logIn(BuildContext context, String name, String pass) async {
    final url = Uri.parse('https://libora-api.onrender.com/api/user/login');

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": name, "pass": pass}));

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", name);
        await prefs.setString("status", "logged_in");

        moveScreen(context, HomePage(), isPushReplacement: true);
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred :(, please contact Armaan!');
    }
  }

  Future<Map<String, dynamic>?> getUserData(
      BuildContext context, String givenName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = "";

    if (givenName == "") {
      name = prefs.getString("name");
    } else {
      name = givenName;
    }

    if (name == null) {
      showSnackBar(context,
          "You're not logged in, if this is an error please contact Armaan otherwise try again!");
    } else {
      final url = Uri.parse(
          'https://libora-api.onrender.com/api/user/get-user?name=$name');
      try {
        final response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return data;
        }
      } catch (e) {
        showSnackBar(context, 'Error occurred :(, please contact Armaan!');
      }
    }
  }

  Future<bool> followUser(BuildContext context, String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get current user's name from SharedPreferences
    String? currentUserName = prefs.getString("name");

    if (currentUserName == null) {
      showSnackBar(context, "You're not logged in. Please log in first.");
      return false;
    }

    try {
      // First, get the current user's data
      final currentUserData = await getUserData(context, currentUserName);

      // Then, get the target user's data
      final targetUserData = await getUserData(context, username);

      if (currentUserData == null || targetUserData == null) {
        showSnackBar(context, "Error fetching user data.");
        return false;
      }

      // Convert to List<String> to manipulate
      List<dynamic> currentUserFollowing =
          List<dynamic>.from(currentUserData['following'] ?? []);
      List<dynamic> targetUserFollowers =
          List<dynamic>.from(targetUserData['followers'] ?? []);

      bool isCurrentlyFollowing = currentUserFollowing.contains(username);
      bool isTargetFollowedByCurrentUser =
          targetUserFollowers.contains(currentUserName);

      // Prepare updates for both users
      Map<String, dynamic> currentUserUpdates = {};
      Map<String, dynamic> targetUserUpdates = {};

      if (isCurrentlyFollowing) {
        // Unfollow logic
        currentUserFollowing.remove(username);
        targetUserFollowers.remove(currentUserName);
      } else {
        // Follow logic
        currentUserFollowing.add(username);
        targetUserFollowers.add(currentUserName);
      }

      // Prepare updates
      currentUserUpdates['following'] = currentUserFollowing;
      targetUserUpdates['followers'] = targetUserFollowers;

      // Update current user
      final currentUserUpdateUrl =
          Uri.parse('https://libora-api.onrender.com/api/user/update-user');
      final currentUserUpdateResponse = await http.patch(currentUserUpdateUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"name": currentUserName, "updates": currentUserUpdates}));

      // Update target user
      final targetUserUpdateUrl =
          Uri.parse('https://libora-api.onrender.com/api/user/update-user');
      final targetUserUpdateResponse = await http.patch(targetUserUpdateUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": username, "updates": targetUserUpdates}));

      // Check if both updates were successful
      if (currentUserUpdateResponse.statusCode == 200 &&
          targetUserUpdateResponse.statusCode == 200) {
        // Successful follow/unfollow

        return !isCurrentlyFollowing; // Returns true if now following, false if unfollowed
      } else {
        showSnackBar(context, "Failed to update follow status.");
        return false;
      }
    } catch (e) {
      print("Follow/Unfollow Error: $e");
      showSnackBar(context, "An error occurred. Please try again.");
      return false;
    }
  }

  Future<List<UserModel>> searchUsers(
      BuildContext context, String query) async {
    final url = Uri.parse(
        'https://libora-api.onrender.com/api/user/search-users?query=$query');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> users = data['users'];

        if (users.isEmpty) {
          if (context.mounted) showSnackBar(context, "No users found.");
          return [];
        } else {
          if (context.mounted)
            showSnackBar(context, "Found ${users.length} users.");
          List<UserModel> usersList = [];
          for (var user in users) {
            usersList.add(UserModel.fromJson(user));
          }
          return usersList;
        }
      } else {
        if (context.mounted) showSnackBar(context, "Error: ${response.body}");
        return [];
      }
    } catch (e) {
      if (context.mounted)
        showSnackBar(context, 'Error occurred :(, please contact Armaan!');
      return [];
    }
  }
}

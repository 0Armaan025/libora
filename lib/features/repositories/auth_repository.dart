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

  Future<void> getUserData(BuildContext context, String givenName) async {
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
          showSnackBar(context, "Welcome back, ${data['name']}!");
        }
      } catch (e) {
        showSnackBar(context, 'Error occurred :(, please contact Armaan!');
      }
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

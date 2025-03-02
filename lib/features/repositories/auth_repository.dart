import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
              {"name": name, "password": pass, "profileImage": profileImage}));

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

  Future<void> getUserData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString("name");

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
}

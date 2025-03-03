import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Message.dart';
import '../models/space.dart';

class ApiService {
  final String baseUrl = "https://libora-api.onrender.com";

  // Create a new space
  Future createSpace(String name, String person, String code) async {
    print("name: ${person}, person: ${name}, code: ${code}");
    final response = await http.post(
      Uri.parse('$baseUrl/api/space/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': person,
        'person': name,
        'code': code,
      }),
    );

    // to future Armaan, I did this on purpose coz I swapped the values

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username = await prefs.getString('name');
      final spaceName = await prefs.setString("space_name", name);
      final spaceCode = await prefs.setString("space_code", code);
      final inSpace = await prefs.setBool("in_space", true);
      return Space.fromJson(data['space']);
    } else {
      throw Exception('Failed to create space: ${response.body}');
    }
  }

  // Join an existing space
  Future joinSpace(String person, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/space/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'person': person,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username = await prefs.getString('name');
      final spaceName =
          await prefs.setString("space_name", data['space']['name']);
      final spaceCode = await prefs.setString("space_code", code);
      final inSpace = await prefs.setBool("in_space", true);
      return Space.fromJson(data['space']);
    } else {
      throw Exception('Failed to join space: ${response.body}');
    }
  }

  // Leave a space
  Future leaveSpace(String person, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/space/leave'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'person': person,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username = await prefs.getString('name');
      final spaceName = await prefs.setString("space_name", "");
      final spaceCode = await prefs.setString("space_code", "");
      final inSpace = await prefs.setBool("in_space", false);
      return true;
    } else {
      throw Exception('Failed to leave space: ${response.body}');
    }
  }

  // Send a message
  Future<List> sendMessage(String code, String user, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/space/send-message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'user': user,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List messages = [];
      if (data['spaceMessage'] != null) {
        messages =
            List.from(data['spaceMessage'].map((x) => Message.fromJson(x)));
      }
      return messages;
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<List> getPeople(String code) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/space/get-people?code=${code}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List messages = [];
      if (data['people'] != null) {
        messages = List.from(data['people'].map((x) => Message.fromJson(x)));
      }
      return messages;
    } else {
      throw Exception('Failed to get people: ${response.body}');
    }
  }

  Future<List<Space>> getActiveSpaces(BuildContext context) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/space/get'),
      headers: {'Content-Type': 'application/json'},
    );

    print("response: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Space> spaces = [];

      if (data['spaces'] != null) {
        for (var space in data['spaces']) {
          // Create Space object using your factory method
          spaces.add(Space.fromJson(space));
        }
      }

      return spaces;
    } else {
      throw Exception('Failed to get active spaces: ${response.body}');
    }
  }

  // Get messages
  Future<List> getMessages(String code) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/space/get-messages?code=${code}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List messages = [];
      if (data['messages'] != null) {
        messages = List.from(data['messages'].map((x) => Message.fromJson(x)));
      }
      return messages;
    } else {
      throw Exception('Failed to get messages: ${response.body}');
    }
  }
}

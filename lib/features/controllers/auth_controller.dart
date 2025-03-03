import 'package:flutter/material.dart';
import 'package:libora/features/models/User.dart';
import 'package:libora/features/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signUp(BuildContext context, String name, String pass,
      String profileImage) async {
    try {
      print('in controller function');
      await _authRepository.signUp(name, pass, context, profileImage);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logIn(BuildContext context, String name, String pass) async {
    try {
      await _authRepository.logIn(context, name, pass);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(
      BuildContext context, String name) async {
    try {
      return await _authRepository.getUserData(context, name);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> searchUsers(
      BuildContext context, String query) async {
    try {
      return await _authRepository.searchUsers(context, query);
    } catch (e) {
      rethrow;
    }
  }
}

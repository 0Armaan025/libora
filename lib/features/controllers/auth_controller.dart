import 'package:flutter/material.dart';
import 'package:libora/features/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signUp(BuildContext context, String name, String pass) async {
    try {
      await _authRepository.signUp(name, pass, context);
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

  Future<void> getUserDetails(BuildContext context) async {
    try {
      await _authRepository.getUserData(context);
    } catch (e) {
      rethrow;
    }
  }
}

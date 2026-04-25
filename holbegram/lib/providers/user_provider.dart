import 'package:flutter/material.dart';

import '../methods/auth_methods.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethods = AuthMethode();

  Users? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      Users user = await _authMethods.getUserDetails();
      _user = user;
    } catch (e) {
      _user = null;
    }

    notifyListeners();
  }
}
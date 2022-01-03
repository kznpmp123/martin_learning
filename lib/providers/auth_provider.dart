import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:optimize/models/User.dart';
import 'package:optimize/network/auth_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = "";
  late User currentUser;

  String get token {
    if (this._token == "") {
      tryAutoLogin();
    }
    return this._token;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userToken')) {
      return false;
    }
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);
    _token = storedData['token'];

    notifyListeners();

    return true;
  }

  bool get isAuth {
    if (_token != null && _token.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login(var data) async {
    String? fireBaseToken = await FirebaseMessaging.instance.getToken();
    data["register_id"] = fireBaseToken;
    var response = await AuthService.login(data);
    _token = response["data"]["access_token"];
    final prefs = await SharedPreferences.getInstance();
    final storedData = json.encode({'token': _token});
    prefs.setString('userToken', storedData);
    notifyListeners();
  }

  Future<void> register(Map<String, String> _authData) async {
    String? fireBaseToken = await FirebaseMessaging.instance.getToken();
    _authData["register_id"] = fireBaseToken!;
    await AuthService.register(_authData);
  }

  Future<void> logout() async {
    _token = "";

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<void> getUser() async {
    var response = await AuthService.getUser();
    ;
    currentUser = User(
      id: response["data"]["id"],
      username: response["data"]["name"],
      email: response["data"]["email"],
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exeption.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != '';
  }

  String get userID => _userId as String;
  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != '') {
      return _token as String;
    }
    return '';
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD9MHBEk8VK-qVXtS2-5MTqbbXVfCOIDnk';
    try {
      final response = await Dio().post(
        url,
        data: {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );
      _token = response.data['idToken'];
      _userId = response.data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(response.data['expiresIn']),
        ),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userID': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('user', userData);
    } on DioError catch (e) {
      log(e.response!.data['error']['message']);
      throw HttpExeption(e.response!.data['error']['message']);
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) {
      return false;
    }
    final extractedUser =
        jsonDecode(prefs.getString('user')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUser['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUser['token'];
    _userId = extractedUser['userID'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _userId = '';
    _token = '';
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

import 'dart:async'; // for using the timer function
import 'dart:convert'; //we use dart:convert for use json decode

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // to use changeNotifier
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // helps to use shared preferences

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  // ChangeNotifier to use notifyListener()
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    // if token is there then return other wise null
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  final keyIs = 'AIzaSyDOt0_X2u7ZA7cB7Cvxw2yAaLtwRBmHy4o';
  // keyIs // go to your firbase project than settings than project settings and then where you will find the web api key

  // returning the future of void type
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = urlSegment;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout(); // for starting the function for the autologin
      notifyListeners();
      final prefs = await SharedPreferences
          .getInstance(); // this will return the future which will eventually return shared prefernces instance

      // we are also able to set list and int see it's documentation
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expriyDate': _expiryDate.toIso8601String(),
      });

      prefs.setString(
          'userData', userData); // storing string in shared preferences
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$keyIs';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$keyIs';
    return _authenticate(email, password, url);
  }

  // the future will return boolean value
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData'))
      return false; // if the key is not there than return false

    // decode the data will retriving because while storing we encode it
    final extractedUserData = json.decode(prefs.getString('userData'));
    // converting to dateTime field because while storing we convert it into the string
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // if expiry date is before the current date then we will return false means no data
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners(); // turning the listen on
    _autoLogout(); // starting the function auto logout
    return true; // returning true means auto login is approved
  }

  // adding logout function
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    // if there is an already time is going on than we will cancel that time
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData'); // clearing the key which store data
    // prefs.clear(); // helps to clear all the data
  }

  void _autoLogout() {
    // if there is an already time is going on than we will cancel that time
    if (_authTimer != null) _authTimer.cancel();

    final timeToExpiry = _expiryDate
        .difference(DateTime.now())
        .inSeconds; // getting the difference from now time to expiry time

    // timer function is available because of dart async
    _authTimer = Timer(Duration(seconds: timeToExpiry),
        logout); // Timer takes two argument first time in seconds then callback function which will call when time is finished
  }
}

import 'dart:convert'; //we use dart:convert for use json decode 

import 'package:flutter/widgets.dart'; // to use changeNotifier
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier { // ChangeNotifier to use notifyListener()
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    // if token is there then return other wise null 
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  final keyIs = '';
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
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$keyIs';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$keyIs';
    return _authenticate(email, password, url);
  }

}

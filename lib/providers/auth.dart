import 'dart:convert'; //we use dart:convert for use json decode 

import 'package:flutter/widgets.dart'; // to use changeNotifier
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier { // ChangeNotifier to use notifyListener()
  String _token;
  DateTime _expiryDate;
  String _userId;

  // returning the future of void type
  Future<void> _authenticate(
    String email, String password, String urlSegment) async {
    // AIzaSyAtWPEnY_YyJ1E4FXLwnGVgo7hBm9Bhlx0 // go to your firbase project than settings than project settings and then where you will find the web api key
    final url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAtWPEnY_YyJ1E4FXLwnGVgo7hBm9Bhlx0';
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
    print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }



}
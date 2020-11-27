import 'dart:convert'; //we use dart:convert for use json decode 

import 'package:flutter/widgets.dart'; // to use changeNotifier
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier { // ChangeNotifier to use notifyListener()
  String _token;
  DateTime _expiryDate;
  String _userId;

  final keyIs = '';
  

  // returning the future of void type
  Future<void> _authenticate(
    String email, String password, String urlSegment) async {
    // AIzaSyDOt0_X2u7ZA7cB7Cvxw2yAaLtwRBmHy4o // go to your firbase project than settings than project settings and then where you will find the web api key
    final url = urlSegment;

    try{
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
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']); // this throw is catch by the it catch block
      }
    } catch(err) {
      throw err; // now we throw the error which is catch by the function who use this function
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
import 'dart:convert'; // thses offeres tools to converting data like the object data to json data

import 'package:flutter/foundation.dart'; // to use ChangeNot
import 'package:http/http.dart' as http; // so we normally use it like http.

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false, // default value of false
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  // to set favorite and unfavorite
  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-learn-f4b08.firebaseio.com/products/$id.json?auth=$token';
    try {
      final response = await http.patch(
        // helps to updating the data in the firebase
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (err) {
      _setFavValue(oldStatus);
    }
  }
}

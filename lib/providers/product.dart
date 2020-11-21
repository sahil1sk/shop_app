import 'package:flutter/foundation.dart'; // to use ChangeNot

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

  // to set favorite and unfavorite
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    // notifyListeners(); available because of ChangeNotifier
    // when this will run the only widgets not other only widgets that use this provider will rebuilt again 
    // they understand there is some change happen in provider so they adopt that change
    notifyListeners();
  }
}
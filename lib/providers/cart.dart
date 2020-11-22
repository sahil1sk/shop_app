import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  // here map key is of String type and its value of CartItem type
  Map<String, CartItem> _items = {};

  // returning the cartItems
  Map<String, CartItem> get items {
    return {..._items};
  }

  // for counting total no of cart item
  int get itemCount {
    return _items.length;
  }

  // for returning total amount
  double get totalAmount {
    var total = 0.0;
    // for go upon each object we using for loop
    _items.forEach((key, cartItem) { 
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // adding item in cart function
  void addItem(String productId, double price, String title) {
    // checking the if any key match with productId
    if (_items.containsKey(productId)) {
      // .update give the funtion back with existing element
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.title, 
          title: existingCartItem.title, 
          quantity: existingCartItem.quantity + 1, 
          price: existingCartItem.price,
        ));
    } else {
      // .putIfAbsent take funtion that creates the value
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

}
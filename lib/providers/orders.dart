import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  // returning the copy of list of orders
  List<OrderItem> get orders {
    return [..._orders];
  }

  // helps to add the orders
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutter-learn-f4b08.firebaseio.com/orders.json';
    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp
            .toIso8601String(), // converting into the special string  so that we will convert into the datetime later
        'products': cartProducts.map((cp) {
          return {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          };
        }).toList(),
      }),
    );

    // helps to add at 0 index means at first place
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));

    notifyListeners();
  }
}

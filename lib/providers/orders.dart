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

  // getting the orders from the firebase
  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-learn-f4b08.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return; // if there is no data then simply return
    // we are getting through map using for each
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  )) // converting the map data into list finally
              .toList()));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
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

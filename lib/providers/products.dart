import 'package:flutter/material.dart';

import './product.dart';


// with help to add mixin it is like light inheritance
// using with we merge other class features or properties
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items]; // returning the copy of items
  }

  List<Product> get favoriteItems {
    // returning the items where favorite is true
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // return type of Product
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id); // getting the item using id
  }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct); // adding the product in the list
    //_items.insert(0, newProduct); // at the start of the list
    // notifyListeners(); available because of ChangeNotifier
    // when this will run the only widgets not other only widgets that use this provider will rebuilt again 
    // they understand there is some change happen in provider so they adopt that change
    notifyListeners(); 
  }
}
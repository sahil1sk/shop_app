import 'dart:convert'; // thses offeres tools to converting data like the object data to json data

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // so we normally use it like http.

import '../models/http_exception.dart';
import './product.dart';

// with help to add mixin it is like light inheritance
// using with we merge other class features or properties
class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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
    return _items
        .firstWhere((prod) => prod.id == id); // getting the item using id
  }

  // void means our awiat that we use which will not return anything
  Future<void> fetchAndSetProducts() async {
    const url ='https://flutter-learn-f4b08.firebaseio.com/products.json'; // it will create product folder of json type if not there if there then use it    

    try{
      final response =  await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>; // dynamic means any
      final List<Product> loadedProducts = [];
      // going over each item in the map use forEach loop
      extractedData.forEach((prodId, prodData) {  // prodId is the key
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }catch(err){
      throw err;
    }
  }

  // helps to add new products // Future<void> means will return a future
  Future<void> addProduct(Product product) async {
    //const url = 'https://flutter-learn-f4b08.firebaseio.com/'; // our firebase database url
    const url ='https://flutter-learn-f4b08.firebaseio.com/products.json'; // it will create product folder of json type if not there if there then use it
    
    try{
      // http is package which we import
      final response = await http // so here we return http as we know then return then
          .post(
        url,
        body: json.encode({
          // json.encode available because we import dart:convert
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct); // adding the product in the list

      notifyListeners();
    
    } catch (err) {
      print(err);
      throw err;
    }
    

    //_items.insert(0, newProduct); // at the start of the list
    // notifyListeners(); available because of ChangeNotifier
    // when this will run the only widgets not other only widgets that use this provider will rebuilt again
    // they understand there is some change happen in provider so they adopt that change
  }

  // for updating the product
  Future<void> updateProduct(String id, Product editiedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url ='https://flutter-learn-f4b08.firebaseio.com/products/$id.json';
      await http.patch( //in firebase patch request will merge the data which we send 
        url, 
        body: json.encode({
          'title': editiedProduct.title,
          'description': editiedProduct.description,
          'imageUrl': editiedProduct.imageUrl,
          'price': editiedProduct.price,
        }),
      );

      _items[prodIndex] = editiedProduct;
      notifyListeners();
    } else {
      print('');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url ='https://flutter-learn-f4b08.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exisitingProduct = _items[existingProductIndex]; // getting the product refrence
    
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url); 
    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, exisitingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    exisitingProduct = null;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // here we use the provider package to use provider
import 'package:shop_app/screens/auth_screen.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // to wrap with multiple data provider use given way
      providers: [
        ChangeNotifierProvider(
          // available because of provider package
          create: (ctx) =>
              Products(), // creating the instance of class which data we want to provide
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider.value(
          // this approach normally used while providing data to gid and list
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          // this approach normally used while providing data to gid and list
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: AuthScreen(), //ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}

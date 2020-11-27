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
import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // to wrap with multiple data provider use given way
      providers: [
        ChangeNotifierProvider.value(
          // this approach normally used while providing data to gid and list
          value: Auth(),
        ),
        // proxyProvider is just like if the data is not available yet then it will be provided latter
        ChangeNotifierProxyProvider<Auth, Products>( // the Auth data you depend on Products which data you are providing
          // available because of provider package
          update: (ctx, auth, previousProducts) => // proxyProvider helps to provide the proxy data means the data depend on other data
              Products(auth.token, previousProducts == null ? [] : previousProducts.items), // creating the instance of class which data we want to provide
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider.value(
          // this approach normally used while providing data to gid and list
          value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            ),
      ),
    );
  }
}
